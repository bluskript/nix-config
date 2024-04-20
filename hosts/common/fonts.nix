{pkgs, ...}: let
  termify = {
    name,
    fontfile,
    dpi ? 100,
    ptSize ? 10,
    extraWidth ? 9,
    ...
  }: let
    bdf2psf-data = "${pkgs.bdf2psf}/share/bdf2psf";
    inherit (pkgs.lib) hasSuffix;
  in
    pkgs.runCommand name
    {
      buildInputs = with pkgs; [otf2bdf bdf2psf gzip];
      sets = pkgs.lib.concatStringsSep "+" (map (x: "${bdf2psf-data}/${x}") [
        "ascii.set"
        "linux.set"
        "fontsets/Lat2.256"
        "fontsets/Uni1.512"
        "useful.set"
      ]);
    } ''
      ${
        if hasSuffix ".ttf" fontfile || hasSuffix ".otf" fontfile
        then "otf2bdf ${fontfile} -r ${toString dpi} -p ${toString ptSize} -o tmp.bdf || true"
        else if hasSuffix ".bdf" fontfile
        then "cp ${fontfile} tmp.bdf"
        else throw "termify: unrecognised font format: ${fontfile}"
      }

      if ! grep -q AVERAGE_WIDTH tmp.bdf; then
        sed -i 's,POINT_SIZE \(.*\),&\nAVERAGE_WIDTH \1,' tmp.bdf
      fi

      AV=$( sed -n 's,AVERAGE_WIDTH ,,p' tmp.bdf )
      AV=$(( ( AV + ${builtins.toString extraWidth} ) / 10 * 10 ))
      sed -i "/AVERAGE_WIDTH/s, .*, $AV," tmp.bdf

      bdf2psf --fb tmp.bdf ${bdf2psf-data}/standard.equivalents $sets 512 - | gzip -k - > $out
    '';
in {
  stylix.fonts = {
    serif = {
      package = pkgs.eb-garamond;
      name = "EB Garamond";
    };
    monospace = {
      package = pkgs.cozette;
      name = "Cozette";
    };
    sansSerif = {
      package = pkgs.cozette;
      name = "Cozette";
    };
    # sansSerif = {
    #   package = pkgs.geist-font-sans;
    #   name = "Geist";
    # };
    # monospace = {
    #   package = pkgs.geist-font-mono;
    #   name = "Geist Mono Code";
    # };
    emoji = {
      package = pkgs.twitter-color-emoji;
      name = "Twitter Color Emoji";
    };
  };

  console.font = termify {
    name = "cozette.psf.gz";
    earlySetup = true;
    useXkbConfig = true;
    fontfile = "${pkgs.cozette}/share/fonts/misc/cozette.bdf";
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      # this fixes emoji stuff
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Cozette"
          "CozetteVector"
          # "Ark Pixel 10px Monospaced"
          # "Geist"
          "Noto Sans CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font"
        ];
        serif = [
          "EB Garamond"
          "Noto Serif CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font"
        ];
        monospace = [
          # "Geist Mono Code"
          "Cozette"
          "CozetteVector"
          # "Ark Pixel 10px Monospaced"
          "Noto Sans Mono CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font Mono"
        ];
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    # font packages that should be installed
    packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      iosevka-bin
      twitter-color-emoji
      inter
      eb-garamond
      geist-font-sans
      geist-font-mono
      # ark-pixel-font
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
  environment.systemPackages = with pkgs; let
    FontFreeType = perlPackages.buildPerlPackage {
      pname = "Font-FreeType";
      version = "0.16";
      src = fetchurl {
        url = "mirror://cpan/authors/id/D/DM/DMOL/Font-FreeType-0.16.tar.gz";
        hash = "sha256-ton+L6jIkKvP4aJXkWqL7dCAa3wpXxrHC+eyhOMVmPM=";
      };
      outputs = ["out" "dev"];
      buildInputs = with pkgs.perlPackages; [freetype DevelChecklib FileWhich TestWarnings];
      meta = {
        license = with lib.licenses; [artistic1 gpl1Plus];
      };
    };
    test-font = pkgs.writeScriptBin "test-font" ''
      #!${pkgs.perl.withPackages (p: [FontFreeType])}/bin/perl
      use strict;
      use warnings;
      use Font::FreeType;
      my ($char) = @ARGV;
      foreach my $font_def (`fc-list`) {
          my ($file, $name) = split(/: /, $font_def);
          my $face = Font::FreeType->new->face($file);
          my $glyph = $face->glyph_from_char($char);
          if ($glyph) {
              print $font_def;
          }
      }
    '';
  in [
    test-font
  ];
}

{pkgs, ...}: {
  stylix.fonts = {
    serif = {
      package = pkgs.eb-garamond;
      name = "EB Garamond";
    };
    sansSerif = {
      package = pkgs.geist-font-sans;
      name = "Geist";
    };
    emoji = {
      package = pkgs.twitter-color-emoji;
      name = "Twitter Color Emoji";
    };
    monospace = {
      package = pkgs.geist-font-mono;
      name = "Geist Mono Code";
    };
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      # this fixes emoji stuff
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Geist"
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
          "Giest Mono Code"
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

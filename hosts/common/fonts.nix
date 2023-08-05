{pkgs, ...}: {
  stylix.fonts = {
    serif = {
      package = pkgs.eb-garamond;
      name = "EB Garamond";
    };
    sansSerif = {
      package = pkgs.inter;
      name = "Inter Light";
    };
    emoji = {
      package = pkgs.twitter-color-emoji;
      name = "Twitter Color Emoji";
    };
    monospace = {
      package = pkgs.jetbrains-mono;
      name = "Jetbrains Mono Light";
    };
  };

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      # this fixes emoji stuff
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Inter Light"
          "Noto Sans CJK SC"
          "Twitter Color Emoji"
          "Symbols Nerd Font"
        ];
        serif = [
          "Inter"
          "Noto Serif CJK SC"
          "Poly"
          "Twitter Color Emoji"
          "Symbols Nerd Font"
        ];
        monospace = [
          "Jetbrains Mono Light"
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
      material-icons
      material-design-icons
      poly
      noto-fonts
      noto-fonts-cjk
      iosevka-bin
      twitter-color-emoji
      inter
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}

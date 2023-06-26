{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = false;
    fontconfig = {
      # this fixes emoji stuff
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Fira Sans"
          "Noto Sans CJK SC"
          "Symbols Nerd Font"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Poly"
          "Symbols Nerd Font"
        ];
        monospace = [
          "Iosevka Term"
          "Noto Sans Mono CJK SC"
          "Symbols Nerd Font Mono"
        ];
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    # font packages that should be installed
    fonts = with pkgs; [
      corefonts
      material-icons
      material-design-icons
      poly
      fira-code
      noto-fonts
      noto-fonts-cjk
      iosevka-bin
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}

{ pkgs, ... }: {
  fonts.fonts = with pkgs; [
    poly
    fira-code
    noto-fonts
    noto-fonts-cjk
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  fonts.fontconfig.defaultFonts = {
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
			"Symbols Nerd Font Mono"
      "FiraCode"
      "Noto Sans Mono CJK SC"
    ];
  };
}

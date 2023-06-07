{ pkgs, ... }: {
  fonts.fonts = with pkgs; [
    poly
    fira-code-symbols
    fira-code
    noto-fonts
    noto-fonts-cjk
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Fira Sans"
      "Noto Sans CJK SC"
    ];
    serif = [
      "Noto Serif CJK SC"
      "Poly"
    ];
    monospace = [
      "FiraCode Nerd Font Mono"
      "Noto Sans Mono CJK SC"
    ];
  };
}

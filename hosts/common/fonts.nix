{ pkgs, ... }: {
  fonts.fonts = with pkgs; [
    poly
    noto-fonts
    noto-fonts-cjk
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Fira Sans"
      "Noto Sans CJK SC"
    ];
    serif = [
      "Poly"
      "Noto Serif CJK SC"
    ];
    monospace = [
      "JetBrainsMono Nerd Font"
      "Noto Sans Mono CJK SC"
    ];
  };
}

{
  config,
  pkgs,
  stdenvNoCC,
  ...
}: {
  home.packages = with pkgs; [
    qt5ct
    pkgs.libsForQt5.breeze-qt5
    (catppuccin-kvantum.override {
      accent = "Mauve";
      variant = "Mocha";
    })
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = "Catppuccin-Mocha-Mauve";
  };
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };
}

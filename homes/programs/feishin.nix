{pkgs, ...}: {
  home.packages = [
    (
      pkgs.nixpaked.feishin ({sloth, ...}: {
        bubblewrap = {
          extraStorePaths = [
            pkgs.mpv
          ];
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.config/feishin/config.json")
          ];
        };
      })
    )
  ];

  xdg.configFile."feishin/config.json" = {
    enable = true;
    text = builtins.toJSON {
      window_has_frame = true;
      mpv_path = "${pkgs.mpv}/bin/mpv";
      window_exit_to_tray = true;
      window_minimize_to_tray = true;
    };
  };
}

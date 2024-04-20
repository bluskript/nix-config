{pkgs, ...}: {
  imports = [
    ./base_cli.nix
    ../nix.nix
    ../boot.nix
    ../auth.nix
    ../audio.nix
    ../video.nix
    ../fonts.nix
    ../flatpak.nix
    ../printing.nix
    ../work.nix
    ../networking/dns
    ../networking/sshd.nix
    ../networking/podman.nix
    ../stylix-prefs.nix
  ];

  hardware.keyboard.qmk.enable = true;

  networking.networkmanager.enable = true;

  security.polkit.enable = true;

  nix.settings.trusted-users = ["@wheel"];

  programs.hamster.enable = true;

  systemd = {
    coredump = {
      extraConfig = ''
        Storage=external
        Compress=no
        Directory=/tmp
      '';
    };
    services = {
      NetworkManager-wait-online.enable = false;
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

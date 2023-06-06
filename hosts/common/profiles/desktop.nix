{ pkgs, ... }: {
  imports = [
    ./base_cli.nix
    ../nix.nix
    ../boot.nix
    ../auth.nix
    ../audio.nix
    ../video.nix
    ../fonts.nix
    ../printing.nix
    ../networking/dns.nix
    ../networking/sshd.nix
    ../networking/podman.nix
  ];

  dns.encryption.enable = true;
  networking.networkmanager.enable = true;

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
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

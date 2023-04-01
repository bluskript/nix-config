# hosts/server.nix
#
# Only to be used for headless servers, at home or abroad, with more
# security/automation-minded configuration.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/hardened.nix")
  ];

  services.fail2ban.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
  };

  systemd = {
    services.clear-log = {
      description = "Clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=21d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };
}

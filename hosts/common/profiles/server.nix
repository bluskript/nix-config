# hosts/server.nix
#
# Only to be used for headless servers, at home or abroad, with more
# security/automation-minded configuration.
{
  inputs,
  outputs,
  config,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/hardened.nix")
    ./base_cli.nix
    ../nix.nix
    ../networking/dns.nix
    ../networking/sshd.nix
  ];


  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      nixosConfig = config;
    };
    # useGlobalPkgs = true;
    # useUserPackages = true;
    users = {
      blusk = import ../../homes/blusk_server/home.nix;
    };
  };

  dns.encryption.enable = false;
  dns.nameservers = [ "1.1.1.1" ];
  services.openssh.enable = true;
  # environment.noXlibs = true;

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
      wantedBy = ["timers.target"];
      partOf = ["clear-log.service"];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };

  services.logrotate.checkConfig = false;
  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.efi.canTouchEfiVariables = false;
}

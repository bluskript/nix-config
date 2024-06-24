{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.xornet-reporter;
in {
  options.services.xornet-reporter = {
    enable = lib.mkEnableOption "xornet-reporter";

    user = lib.mkOption {
      type = lib.types.str;
      default = "xornet";
      description = "User under which xornet-reporter will run.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "xornet";
      description = "Group under which xornet-reporter will run.";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Configuration file for xornet-reporter.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.xornet-reporter = {
      description = "Xornet reporter";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "/etc/xornet";
        ExecStart = "${pkgs.xornet-reporter}/bin/xornet-reporter --silent";
        Restart = "always";
        RestartSec = "10";
      };
    };
    users = {
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };
      groups.${cfg.group} = {};
    };

    environment.etc."xornet/config.json".source = cfg.configFile;
  };
}

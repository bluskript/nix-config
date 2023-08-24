{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.stalwart-mail;
  configFormat = pkgs.formats.toml {};
in {
  options.services.stalwart-mail = {
    enable = mkEnableOption "Stalwart Mail Server";
    config = mkOption {
      type = configFormat.type;
      default = {};
      description = "Configuration attribute set";
    };
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The absolute path to the configuration file.";
    };
  };

  config = mkIf cfg.enable (let
    configFile =
      if cfg.configFile != null
      then cfg.configFile
      else configFormat.generate "config.toml" cfg.config;
  in {
    assertions = [
      {
        assertion = (cfg.configFile != null) -> (cfg.config == {});
        message = "Either but not both `configFile` and `config` should be specified for stalwart.";
      }
    ];
    environment.systemPackages = [pkgs.stalwart-mail];
    systemd.services.stalwart-mail = {
      description = "Stalwart Mail Server";
      restartTriggers = [configFile];
      after = [
        "network-online.target"
      ];
      conflicts = [
        "postfix.service"
        "sendmail.service"
        "exim4.service"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      serviceConfig = {
        Type = "simple";
        LimitNOFILE = "65536";
        KillMode = "process";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        RestartSec = "5";
        ExecStart = "${pkgs.stalwart-mail}/bin/stalwart-mail --config=${configFile}";
        PermissionsStartOnly = "true";
        StandardOutput = "syslog";
        StandardError = "syslog";
        SyslogIdentifier = "stalwart-mail";
      };
    };
  });
}

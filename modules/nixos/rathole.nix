{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.rathole;
in {
  options.services.rathole = {
    enable = mkEnableOption "Reverse proxy with rathole";
    package = mkOption {
      type = types.package;
      default = pkgs.rathole;
    };
    clientCfgPath = mkOption {
      type = with types; nullOr path;
      default = null;
    };
    serverCfgPath = mkOption {
      type = with types; nullOr path;
      default = null;
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    systemd.user.services = {
      rathole-client = mkIf (cfg.clientCfgPath != null) {
        Service = {
          ExecStart = "${cfg.package}/bin/rathole --client ${cfg.clientCfgPath}";
          Restart = "on-failure";
          RestartSec = 5;
          LimitNOFILE = 1000000007;
          NoNewPrivileges = true;
        };
        Install.WantedBy = ["default.target"];
      };
      rathole-server = mkIf (cfg.serverCfgPath != null) {
        Service = {
          ExecStart = "${cfg.package}/bin/rathole --server ${cfg.serverCfgPath}";
          Restart = "on-failure";
          RestartSec = 5;
          LimitNOFILE = 1000000007;
          NoNewPrivileges = true;
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}

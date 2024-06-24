{
  pkgs,
  config,
  ...
}: let
  hostName = "firefox.blusk.dev";
  port = 5000;
  secretPath = config.age.secrets.firefox-syncserver.path;
in {
  age.secrets.firefox-syncserver.file = ../../secrets/firefox-syncserver.age;

  services.nginx.virtualHosts."${hostName}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString port}/";
      recommendedProxySettings = true;
    };
  };

  containers.firefox-syncserver = {
    autoStart = true;
    ephemeral = true;
    forwardPorts = [
      {
        containerPort = port;
        hostPort = port;
      }
    ];
    bindMounts."${secretPath}" = {
      hostPath = secretPath;
      isReadOnly = true;
    };
    config = {...}: {
      # HACK! theres this bug that isnt fixed with nixos containers: https://github.com/NixOS/nix/issues/6898
      services.logrotate.checkConfig = false;

      services.nginx.virtualHosts."localhost".listen = [
        {
          addr = "0.0.0.0";
          port = port;
        }
      ];

      services.firefox-syncserver = {
        enable = true;
        singleNode = {
          enable = true;
          hostname = hostName;
          capacity = 1;
        };
        settings.port = port;
        secrets = config.age.secrets.firefox-syncserver.path;
      };

      services.mysql.package = pkgs.mariadb;

      networking.firewall.allowedTCPPorts = [port];

      environment.etc."resolv.conf".text = "nameserver 1.1.1.1";
      system.stateVersion = "23.05";
    };
  };
}

{...}: {
  services.nginx.virtualHosts."rss.blusk.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:1800/";
  };
  containers.rssbridge = {
    autoStart = true;
    ephemeral = true;
    forwardPorts = [
      {
        containerPort = 1800;
        hostPort = 1800;
      }
    ];
    config = {...}: {
      services.rss-bridge = {
        enable = true;
        virtualHost = "localhost";
        whitelist = ["Twitter" "YouTube" "Reddit" "Twitch"];
      };
      services.nginx.virtualHosts."localhost".listen = [
        {
          addr = "0.0.0.0";
          port = 1800;
        }
      ];
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [80];
      };
      services.logrotate.checkConfig = false;
      environment.etc."resolv.conf".text = "nameserver 1.1.1.1";
      system.stateVersion = "23.05";
    };
  };
}

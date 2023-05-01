{ ... }: {
  services.nginx.virtualHosts."rss.blusk.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://192.168.100.10:80";
  };
  containers.rssbridge = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    hostAddress6 = "fc00::1";
    config = { ... }: {
      services.rss-bridge = {
        enable = true;
        virtualHost = "localhost:80";
        whitelist = [ "Twitter" "YouTube" "Reddit" "Twitch" ];
      };
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
      environment.etc."resolv.conf".text = "nameserver 1.1.1.1";
      system.stateVersion = "23.05";
    };
  };
}

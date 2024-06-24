{...}: let
  hostname = "stream.blusk.dev";
  webPort = 1337;
  rtmpPort = 1935;
in {
  services.nginx.virtualHosts."${hostname}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString webPort}/";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
  services.owncast = {
    enable = true;
    port = webPort;
    rtmp-port = rtmpPort;
    openFirewall = true;
  };
}

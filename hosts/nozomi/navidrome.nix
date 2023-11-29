{...}: let
  port = 4533;
in {
  services.nginx.virtualHosts."navidrome.blusk.dev" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString port}/";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    port
  ];
}

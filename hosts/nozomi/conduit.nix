{
  config,
  pkgs,
  ...
}: let
  server_name = "matrix.blusk.dev";
  _wellKnownFileClient = pkgs.writeText "client" (
    builtins.toJSON
    {
      "m.homeserver"."base_url" = "https://${server_name}";
      "org.matrix.msc3575.proxy"."url" = "https://matrix.gaze.systems";
    }
  );
  _wellKnownFileServer =
    pkgs.writeText "server"
    (builtins.toJSON {"m.server" = "${server_name}:443";});
  wellKnownFiles = pkgs.runCommand "well-known" {} ''
    mkdir -p $out
    cp ${_wellKnownFileServer} $out/server
    cp ${_wellKnownFileClient} $out/client
  '';
in {
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = server_name;
      max_request_size = 1000 * 1000 * 100 * 20;
      allow_registration = true;
      allow_federation = true;
      trusted_servers = ["matrix.org" "nixos.dev" "conduit.rs"];
      address = "::1";
      port = 6167;
      enable_lightning_bolt = false;
    };
  };

  services.nginx.virtualHosts."${server_name}" = {
    enableACME = true;
    forceSSL = true;
    listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
      {
        addr = "[::]";
        port = 443;
        ssl = true;
      }
      {
        addr = "0.0.0.0";
        port = 8448;
        ssl = true;
      }
      {
        addr = "[::]";
        port = 8448;
        ssl = true;
      }
    ];
    extraConfig = ''
      merge_slashes off;
    '';
    locations."/_matrix/" = {
      proxyPass = "http://localhost:${toString config.services.matrix-conduit.settings.global.port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_buffering off;
      '';
    };
    locations."/.well-known/matrix/".extraConfig = ''
      add_header content-type application/json;
      add_header access-control-allow-origin *;
      alias ${wellKnownFiles}/;
    '';
  };
  # services.nginx.virtualHosts."matrix.blusk.dev" = {
  #  locations."/.well-known/matrix/".extraConfig = ''
  #    add_header content-type application/json;
  #    add_header access-control-allow-origin *;
  #    alias ${wellKnownFiles}/;
  #  '';
  # };
}

{ config
, pkgs
, inputs
, ...
}:
let
  _wellKnownFileClient = pkgs.writeText "client" (
    builtins.toJSON
      { "m.homeserver"."base_url" = "https://matrix.blusk.dev"; }
  );
  _wellKnownFileServer =
    pkgs.writeText "server"
      (builtins.toJSON { "m.server" = "matrix.blusk.dev:443"; });
  wellKnownFiles = pkgs.runCommand "well-known" { } ''
    mkdir -p $out
    cp ${_wellKnownFileServer} $out/server
    cp ${_wellKnownFileClient} $out/client
  '';
in
{
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = "matrix.blusk.dev";
      max_request_size = 1000 * 1000 * 100 * 20;
      allow_registration = true;
      allow_federation = true;
      trusted_servers = [ "matrix.org" "nixos.dev" "conduit.rs" ];
      address = "::1";
      port = 6167;
      enable_lightning_bolt = false;
    };
  };

  services.nginx.virtualHosts."matrix.blusk.dev" = {
    enableACME = true;
    forceSSL = true;
    clientMaxBodySize = "200m";
    locations."/".proxyPass = "http://localhost:${toString config.services.matrix-conduit.settings.global.port}";
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

  services.nginx.enable = true;
}

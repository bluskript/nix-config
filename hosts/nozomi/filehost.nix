{...}: {
  services.nginx.virtualHosts."files.blusk.dev" = {
    enableACME = true;
    forceSSL = true;
    root = "/nix/persist/filehost";
  };
}

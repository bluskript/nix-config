{ lib, pkgs, ... }:
let
  ableton = pkgs.fetchurl {
    url = "https://www.bamsoftware.com/hacks/zipbomb/zbxl.zip";
    sha256 = "sha256:0i3ph638mmx2a3494i8mr0im73fps3lfl6dabqs0zzd79rbqzzga";
  };
in
{
  services.nginx.virtualHosts."ableton.zip" = {
    enableACME = true;
    forceSSL = true;
    root = "/";
    locations."/" = {
      tryFiles = "${ableton} =404";
      extraConfig = ''
        add_header Content-Disposition 'attachment; "filename=ableton.zip"';
      '';
    };
  };
}

{ inputs, ... }:
let
  blusk = import ../common/blusk.nix;
in
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 8448 ];
    allowedUDPPortRanges = [ ];
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = blusk.email;
  };
}

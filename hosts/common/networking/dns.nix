{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    dns = {
      nameservers = mkOption {
        type = types.listOf types.string;
        default = ["9.9.9.11:53"];
      };
      # bad technology pls dont use
      dhcp = {
        enable = mkEnableOption "dhcp support";
      };
      encryption = {
        enable =
          mkEnableOption "dns encryption via dnscrypt-proxy2"
          // {
            default = true;
          };
        serverNames = mkOption {
          type = types.listOf types.string;
          default = ["quad9-dnscrypt-ip4-nofilter-pri" "quad9-doh-ip6-port443-nofilter-pri"];
        };
      };
    };
  };

  config = let
    cfg = config.dns;
  in
    mkMerge [
      {
        networking = {
          nameservers =
            if cfg.encryption.enable
            then ["127.0.0.1" "::1"]
            else cfg.nameservers;
        };
      }
      (mkIf (!cfg.dhcp.enable)
        {
          networking = {
            dhcpcd.extraConfig = "nohook resolv.conf";
            networkmanager = {
              dns = "none";
            };
          };
        })
      (mkIf cfg.encryption.enable {
        # systemd.services.dnscrypt-proxy2.after = mkIf config.services.mullvad-vpn.enable [ "mullvad-vpn.service" ];
        services.dnscrypt-proxy2 = {
          enable = true;
          settings = {
            bootstrap_resolvers = cfg.nameservers;
            ipv6_servers = true;
            require_dnssec = true;
            require_nolog = true;
            require_nofilter = true;
            odoh_servers = true;
            server_names = cfg.encryption.serverNames;
            sources = {
              # odoh-relays = {
              #   urls = [
              #     "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
              #     "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
              #   ];
              #   minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              #   cache_file = "odoh-relays.md";
              # };
              # odoh-servers = {
              #   urls = [
              #     "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
              #     "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
              #   ];
              #   minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              #   cache_file = "odoh-servers.md";
              # };
              public-resolvers = {
                urls = [
                  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                  "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
                ];
                cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
                minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              };
            };
          };
        };

        systemd.services.dnscrypt-proxy2.serviceConfig = {
          StateDirectory = "dnscrypt-proxy";
        };
      })
    ];
}

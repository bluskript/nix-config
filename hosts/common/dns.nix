{ config, lib, ... }: with lib; {
  options = {
    dns = {
      nameservers = mkOption {
        type = types.listOf types.string;
        default = [ "1.1.1.1" ];
      };
      # bad technology pls dont use
      dhcp = {
        enable = mkEnableOption "dhcp support";
      };
      encryption = {
        enable = mkEnableOption "dns encryption via dnscrypt-proxy2" // {
          default = true;
        };
        serverNames = mkOption {
          type = types.listOf types.string;
          default = [ "cloudflare" "cloudflare-ipv6" ];
        };
      };
    };
  };

  config = let cfg = config.dns; in
    mkMerge [
      {
        networking = {
          nameservers =
            if cfg.encryption.enable
            then [ "127.0.0.1" "::1" ]
            else cfg.nameservers;
        };
      }
      (mkIf (!cfg.dhcp.enable)
        {
          networking = {
            dhcpcd.extraConfig = "nohook resolv.conf";
            networkmanager = {
              enable = true;
              dns = "none";
            };
          };
        })
      (mkIf cfg.encryption.enable {
        services.dnscrypt-proxy2 = {
          enable = true;
          settings = {
            ipv6_servers = true;
            require_dnssec = true;

            sources.public-resolvers = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
              ];
              cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };
            server_names = cfg.encryption.serverNames;
          };
        };

        systemd.services.dnscrypt-proxy2.serviceConfig = {
          StateDirectory = "dnscrypt-proxy";
        };
      })
    ];
}

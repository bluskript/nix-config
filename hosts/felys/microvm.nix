{
  pkgs,
  inputs,
  config,
  ...
}: let
  system = "x86_64-linux";
in {
  boot.kernelModules = ["macvtap" "xt_MASQUERADE"];

  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = "microvm";
    };
    networks."10-microvm" = {
      matchConfig.Name = "microvm";
      networkConfig = {
        DHCPServer = true;
        IPv6SendRA = true;
      };
      addresses = [
        {
          addressConfig.Address = "10.0.0.1/24";
        }
        {
          addressConfig.Address = "fd12:3456:789a::1/64";
        }
      ];
      ipv6Prefixes = [
        {
          ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
        }
      ];
    };
    networks."11-microvm" = {
      matchConfig.Name = "vm-*";
      # Attach to the bridge that was configured above
      networkConfig.Bridge = "microvm";
    };
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eno1";
    internalInterfaces = ["microvm"];
  };

  environment.systemPackages = let
    my-microvm = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        # this runs as a MicroVM
        inputs.microvm.nixosModules.microvm

        ({
          config,
          lib,
          pkgs,
          ...
        }: {
          microvm = {
            hypervisor = "cloud-hypervisor";
            graphics.enable = true;
            mem = 4000;
            interfaces = [
              {
                type = "tap";
                id = "vm-1";
                mac = "02:68:b3:29:da:98";
              }
            ];
          };

          networking.hostName = "graphical-microvm";
          system.stateVersion = config.system.nixos.version;
          nixpkgs.overlays = [inputs.microvm.overlay];

          networking.useNetworkd = true;
          systemd.network = {
            enable = true;
            networks."10-ens3" = {
              name = "ens3";
              gateway = ["10.0.0.1"];
              dns = ["1.1.1.1"];
              DHCP = "yes";
              address = ["10.0.0.2/24"];
            };
          };

          services.getty.autologinUser = "user";
          users.users.user = {
            password = "";
            group = "user";
            isNormalUser = true;
            extraGroups = ["wheel" "video"];
          };
          users.groups.user = {};
          security.sudo = {
            enable = true;
            wheelNeedsPassword = false;
          };

          environment.sessionVariables = {
            WAYLAND_DISPLAY = "wayland-1";
            DISPLAY = ":0";
            QT_QPA_PLATFORM = "wayland"; # Qt Applications
            GDK_BACKEND = "wayland"; # GTK Applications
            XDG_SESSION_TYPE = "wayland"; # Electron Applications
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
          };

          systemd.user.services.wayland-proxy = {
            enable = true;
            description = "Wayland Proxy";
            serviceConfig = with pkgs; {
              # Environment = "WAYLAND_DISPLAY=wayland-1";
              ExecStart = "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
              Restart = "on-failure";
              RestartSec = 5;
            };
            wantedBy = ["default.target"];
          };

          environment.systemPackages = with pkgs; [
            xdg-utils # Required
            firefox
          ];

          hardware.opengl.enable = true;
        })
      ];
    };
  in [
    my-microvm.config.microvm.declaredRunner
  ];
}

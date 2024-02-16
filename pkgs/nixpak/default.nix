{
  inputs,
  pkgs,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (nixpkgs) lib;
    inherit pkgs;
  };
in {
  # A highly restricted nushell that doesn't get access to the rest of the system.
  nushellFull = extraConfig: (mkNixPak {
    config = {sloth, ...}: {
      app.package = pkgs.nushellFull;

      imports = [
        "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
        extraConfig
      ];
    };
  });

  nicotine-plus = extraConfig: (mkNixPak {
    config = {sloth, ...}: {
      flatpak.appId = "org.nicotine_plus.Nicotine";
      app.package = pkgs.nicotine-plus;

      imports = [
        "${inputs.nixpak-pkgs}/pkgs/modules/gui-base.nix"
        "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
        extraConfig
      ];

      bubblewrap = {
        bind.rw = [
          (sloth.env "XDG_RUNTIME_DIR")
          (sloth.concat' sloth.homeDir "/.config/nicotine")
        ];
      };
    };
  });

  feishin = extraConfig: (mkNixPak {
    config = {sloth, ...}: {
      flatpak.appId = "com.myself.feishin";
      app.package = pkgs.feishin;

      imports = [
        "${inputs.nixpak-pkgs}/pkgs/modules/gui-base.nix"
        "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
        extraConfig
      ];

      dbus.policies = {
        "org.freedesktop.DBus" = "talk";
      };

      bubblewrap = {
        network = true;
        sockets = {
          pipewire = true;
          pulse = true;
        };
        bind.rw = [
          (sloth.concat' sloth.homeDir "/.config/feishin")
          "/tmp/.X11-unix/X0"
        ];
        bind.ro = [
          (sloth.concat' sloth.homeDir "/.nix-profile/bin/mpv")
        ];

        tmpfs = ["/tmp"];
      };
    };
  });
  firefox = let
    pkg = pkgs.firefox-hardenedsupport;
  in
    extraConfig: (mkNixPak {
      config = {
        sloth,
        config,
        ...
      }: {
        imports = [
          "${inputs.nixpak-pkgs}/pkgs/modules/gui-base.nix"
          "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
          extraConfig
        ];

        flatpak.appId = "org.mozilla.Firefox";

        app.package = pkg;

        etc.sslCertificates.enable = true;

        dbus.policies = {
          "${config.flatpak.appId}" = "own";
          "${config.flatpak.appId}.*" = "own";
          "org.freedesktop.Notifications" = "talk";
          "org.mpris.MediaPlayer2.firefox.*" = "own";
          "org.freedesktop.FileManager1" = "talk";
          "ca.desrt.dconf" = "talk";
          "org.freedesktop.NetworkManager" = "talk";
        };

        bubblewrap = {
          network = true;
          bind.rw = let
            envSuffix = envKey: sloth.concat' (sloth.env envKey);
          in [
            (sloth.envOr "XAUTHORITY" "/no-xauth")

            (envSuffix "XDG_RUNTIME_DIR" "/doc")
            (envSuffix "XDG_RUNTIME_DIR" "/dconf")
            (sloth.concat' sloth.homeDir "/.mozilla")
          ];
          bind.ro = [
            [
              "${pkg}/lib/firefox"
              "/app/etc/firefox"
            ]
            "/sys/bus/pci"
          ];
        };
      };
    });
}

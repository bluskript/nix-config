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
  vscode = extraConfig: (mkNixPak {
    config = {sloth, ...}: {
      app.package = pkgs.vscode;
      imports = [
        "${inputs.nixpak-pkgs}/pkgs/modules/gui-base.nix"
        "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
        extraConfig
      ];
    };
  });

  # A highly restricted nushell that doesn't get access to the rest of the system.
  nushellFull = extraConfig: (mkNixPak {
    config = {sloth, ...}: {
      app.package = pkgs.nushellFull;

      imports = [
        "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
        extraConfig
      ];

      bubblewrap.bind.ro = [
        "/bin/sh"
        "/usr/bin/env"
      ];
    };
  });

  signal-desktop = extraConfig:
    mkNixPak {
      config = {
        sloth,
        pkgs,
        ...
      }: {
        imports = [
          "${inputs.nixpak-pkgs}/pkgs/modules/gui-base.nix"
          "${inputs.nixpak-pkgs}/pkgs/modules/network.nix"
          extraConfig
        ];

        app.package = pkgs.signal-desktop;

        dbus = {
          enable = true;
          policies = {
            # We need to send notifications
            "org.freedesktop.Notifications" = "talk";
            "org.gnome.Mutter.IdleMonitor" = "talk";
            "org.kde.StatusNotifierWatcher" = "talk";
            "com.canonical.AppMenu.Registrar" = "talk";
            "com.canonical.indicator.application" = "talk";
            "org.ayatana.indicator.application" = "talk";
            # Allow running in background
            "org.freedesktop.portal.Background" = "talk";
            # Allow advanced input methods
            "org.freedesktop.portal.Fcitx" = "talk";
            # This is needed for the tray icon
            "org.kde.*" = "own";

            # FIXME: signal doesn't know how to use this
            # "org.freedesktop.portal.*" = "talk";
          };
        };

        flatpak.appId = "org.signal.Signal";

        bubblewrap = {
          network = true;
          shareIpc = true;

          bind.rw = [
            # double check if this is necessary
            (sloth.runtimeDir)
            (sloth.concat' (sloth.xdgConfigHome) "/Signal")
            # download without a file picker prompt
            (sloth.concat' sloth.homeDir "/Downloads")
          ];
          bind.ro = [
            # pulseaudio socket
            # is this necessary? we already bind a containing directory rw
            (sloth.concat' (sloth.runtimeDir) "/pulse/native")
          ];
        };
      };
    };

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
        network = true;
        shareIpc = true;
        bind.rw = [
          (sloth.runtimeDir)
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

        tmpfs = ["/tmp"];
      };
    };
  });

  obsidian = extraConfig: (mkNixPak {
    config = {sloth, ...}: {
      flatpak.appId = "com.myself.obsidian";
      app.package = pkgs.obsidian;

      imports = [
        "${inputs.nixpak-pkgs}/pkgs/modules/gui-base.nix"
        extraConfig
      ];

      bubblewrap = {
        bind.rw = [
          "/persist/home/blusk/vault"
          "/tmp/.X11-unix/X0"
          (sloth.concat' sloth.homeDir "/.config/obsidian")
        ];
      };
    };
  });

  firefox = let
    pkg = pkgs.firefox-devedition;
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
          sockets = {
            pipewire = true;
            pulse = true;
          };
          bind.rw = let
            envSuffix = envKey: sloth.concat' (sloth.env envKey);
          in [
            (sloth.concat' sloth.homeDir "/Downloads")
            (sloth.envOr "XAUTHORITY" "/no-xauth")

            (envSuffix "XDG_RUNTIME_DIR" "/at-spi/bus")
            (envSuffix "XDG_RUNTIME_DIR" "/gvfsd")
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

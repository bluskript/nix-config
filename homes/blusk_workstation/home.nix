{
  inputs,
  outputs,
  nixosConfig,
  pkgs,
  config,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    inputs.impermanence.nixosModules.home-manager.impermanence

    ../common/profile-cli.nix
    ../programs/arrpc.nix
    # ../programs/discordrp-mpris.nix
    ../programs/nvim
    ../programs/nvim/neovide.nix
    ../programs/nvim/stylix.nix
    ../programs/qt
    ../programs/gtk.nix
    ../programs/waybar
    ../programs/sway
    ../programs/firefox
    ../programs/virtualisation/virt-manager.nix
    ../programs/virtualisation/looking-glass-client
    ../programs/ranger
    ../programs/tmux.nix
    ../programs/bat.nix
    ../programs/joshuto/default.nix
    ../programs/zathura.nix
    ../programs/feishin.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "blusk";
    homeDirectory = "/home/blusk";
    shellAliases = nixosConfig.environment.shellAliases;
    packages = with pkgs;
      [
        (builtins.getFlake "github:bluskript/nix-inspect?rev=f6c31657c320d655377f0e5c982093a9b1579734").packages.x86_64-linux.default
        distrobox
        ntfs3g
        ncdu
        light
        pavucontrol
        # transmission-gtk
        grim
        slurp
        imv
        mpv
        zip
        unzip
        ripgrep
        skim
        dwt1-shell-color-scripts
        neofetch
        yewtube
        element-desktop
        tmsu
        reaper
        transmission-gtk
        xdg_utils
        papirus-icon-theme
        nix-output-monitor
        wf-recorder
        kagi-cli
      ]
      ++ (let
        guiPrefs = (import ../common/nixpak-hm.nix) {inherit config pkgs;};
        signal-desktop = nixpaked.signal-desktop guiPrefs;
        signal-wrapper = pkgs.writeShellScriptBin "signal-desktop" "sudo -E ${pkgs.iproute2}/bin/ip netns exec torjail sudo -E -u blusk ${signal-desktop}/bin/signal-desktop \"$@\"";
      in [
        signal-wrapper
        (nixpaked.nicotine-plus guiPrefs)
        (nixpaked.obsidian {})
        (nixpaked.vscode {})
        (nixpaked.firefox {
          imports = [guiPrefs];

          bubblewrap.bind.ro = ["/sys/bus/pci"];
        })
      ]);
    persistence."/persist/home/blusk" = {
      allowOther = true;
      directories = [
        ".tmsu"
        ".cache"
        ".gradle"
        ".cargo"
        ".npm"
        ".local/share/zoxide"
        ".config/Element"
        ".config/Signal"
        ".config/shell_gpt"
        ".mozilla/firefox/dev-edition-default"
        ".config/Yubico"
        ".local/share/zsh"
        # note: clear this out every once in a while to make sure it still can install from scratch
        ".local/share/nvim"
        ".local/state/nvim"
        ".local/share/direnv"
        # to make me not go insane reconfiguring output devices all the time
        ".local/state/wireplumber"
        ".local/share/strawberry"
        ".local/share/keyrings"
        ".config/transmission"
        ".config/feishin"
        ".config/nushell/hist"
        ".config/kagi-cli"
        ".local/share/nicotine"
        ".config/nicotine"
        ".config/obsidian"
        ".local/share/zathura"
        ".local/share/hamster"
        {
          directory = ".local/share/containers";
          method = "symlink";
        }
        ".ssh"
        {
          directory = "projects";
          method = "symlink";
        }
      ];
      files = [
        ".bash_history"
        ".config/nushell/history.txt"
      ];
    };
  };

  xdg.configFile = {
    "OpenRGB/main.orp".source = ./main.orp;
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  services.gnome-keyring.enable = true;

  programs.bash.enable = true;

  programs.imv = {
    enable = true;
    settings = {
      binds = {
        y = ''exec wl-copy -t image/png < "$imv_current_file"'';
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncate_to_repo = false;
      };
    };
  };

  programs.alacritty = let
    nixpakNushell = (import ../programs/nushell/nixpak.nix) {inherit pkgs;};
  in {
    enable = true;
    settings = {
      shell.program = "${nixpakNushell.rootShell}/bin/nu";
      window = {
        dynamic_padding = false;
        padding = {
          x = 16;
          y = 4;
        };
      };
      font.bold = {
        family = "CozetteVector";
      };
      # keyboard.bindings = [
      #   {
      #     key = "E";
      #     mods = "Control";
      #     action = "ToggleViMode";
      #   }
      # ];
    };
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/magnet" = ["transmission-gtk.desktop"];
        "x-scheme-handler/element" = "element-desktop.desktop";
        "x-scheme-handler/sgnl" = "signal-desktop.desktop";
        "x-scheme-handler/signalcaptcha" = "signal-desktop.desktop";
        "x-scheme-handler/slack" = "slack.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
      associations = {
        added = {
          "x-scheme-handler/magnet" = "transmission-gtk.desktop";
        };
        removed = {
          "text/plain" = "code.desktop";
          "inode/directory" = "code.desktop";
        };
      };
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

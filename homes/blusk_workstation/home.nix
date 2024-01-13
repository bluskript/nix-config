{
  inputs,
  outputs,
  nixosConfig,
  pkgs,
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
    ../programs/discordrp-mpris.nix
    ../programs/nvim
    ../programs/nvim/neovide.nix
    ../programs/nvim/stylix.nix
    ../programs/qt
    ../programs/gtk.nix
    ../programs/waybar
    # ../programs/eww
    ../programs/sway
    ../programs/firefox
    ../programs/virtualisation/virt-manager.nix
    ../programs/virtualisation/looking-glass-client
    ../programs/ranger
    ../programs/tmux.nix
    ../programs/pidgin.nix
    ../programs/joshuto/default.nix
    # ../programs/nnn.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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
    packages = with pkgs; [
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

      sonixd
      signal-desktop

      nix-output-monitor
    ];
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
        ".config/shell_gpt"
        ".mozilla/firefox/Default"
        ".config/Yubico"
        ".local/share/zsh"
        # note: clear this out every once in a while to make sure it still can install from scratch
        ".local/share/nvim"
        ".local/share/direnv"
        # to make me not go insane reconfiguring output devices all the time
        ".local/state/wireplumber"
        ".local/share/strawberry"
        ".local/share/keyrings"
        ".config/transmission"
        ".config/Sonixd"
        ".local/share/nicotine"
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
        ".config/nicotine/config"
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

  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncate_to_repo = false;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.nushell}/bin/nu";
      window = {
        dynamic_padding = false;
        padding = {
          x = 16;
          y = 4;
        };
      };
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

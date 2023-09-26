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
    ../programs/nvim/neovide.nix
    ../programs/qt
    ../programs/gtk.nix
    ../programs/waybar
    # ../programs/eww
    ../programs/sway
    ../programs/firefox
    ../programs/weechat.nix
    ../programs/virtualisation/virt-manager.nix
    ../programs/virtualisation/looking-glass-client
    ../programs/ranger
    ../programs/tmux.nix
    ../programs/pidgin.nix
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
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };
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
      ranger
      zip
      unzip
      ripgrep
      skim
      dwt1-shell-color-scripts
      neofetch
      musikcube
      yewtube
      element-desktop
      tmsu
      reaper
      transmission-gtk
      xdg_utils
      shell_gpt
      entr
      inputs.llamacpp.packages.${pkgs.system}.default

      papirus-icon-theme

      strawberry
      signal-desktop

      vscode
      # pkgs.mutableai-cli
      # inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    ];
    persistence."/persist/home/blusk" = {
      allowOther = true;
      directories = [
        ".tmsu"
        ".cache"
        ".gradle"
        ".local/share/zoxide"
        # TODO make this declarative
        ".config/weechat"
        ".config/musikcube"
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
        {
          directory = ".local/share/containers";
          method = "symlink";
        }
        ".ssh"
        "projects"
      ];
      files = [
        ".bash_history"
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
      associations.added = {
        "x-scheme-handler/magnet" = "transmission-gtk.desktop";
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

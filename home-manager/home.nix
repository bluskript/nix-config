# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, nixosConfig, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    inputs.impermanence.nixosModules.home-manager.impermanence

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./programs/zsh.nix
    ./programs/waybar
    ./programs/nvim
    ./programs/sway.nix
    ./programs/firefox
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "blusk";
    homeDirectory = "/home/blusk";
    shellAliases = nixosConfig.environment.shellAliases;
    packages = with pkgs; [
      swaylock
      swayidle
      wofi
      alacritty
      ncdu
      light pavucontrol
      grim slurp imv
      # basic cli toolset
      bat fzf ranger micro zip unzip manix ripgrep skim
      dt-shell-color-scripts neofetch
    ];
    persistence."/persist/home/blusk" = {
      allowOther = true;
      directories = [
      	".mozilla/firefox/Default"
      	".config/Yubico"
        ".local/share/zsh"
        ".ssh"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Blusk";
    userEmail = "bluskript@gmail.com"; 
  };

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncate_to_repo = false;
      };
    };
  };

  programs.alacritty.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

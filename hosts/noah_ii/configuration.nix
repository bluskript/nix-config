# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.impermanence.nixosModules.impermanence

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../common/base_cli.nix
    ./nvidia.nix
    ./gpu-passthrough.nix
  ];

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    vfio.enable = true;
  };

  stylix.image = ./wallpaper.jpg;
  stylix.polarity = "dark";

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
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "NoAH-II";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables.EDITOR = "nvim";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager"
      "/var/log"
      "/etc/mullvad-vpn"
      "/var/lib/libvirt"
    ];
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.gvfs.enable = true;

  services.mullvad-vpn.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.wireshark.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  fonts.fonts = with pkgs; [
    poly
    noto-fonts
    noto-fonts-cjk
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = ["FiraCode"]; })
  ];

  fonts.fontconfig.defaultFonts = {
      sansSerif = [
        "Fira Sans"
        "Noto Sans CJK SC"
      ];
      serif = [
        "Poly"
        "Noto Serif CJK SC"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Sans Mono CJK SC"
      ];
  };

  home-manager = {
  	extraSpecialArgs = { inherit inputs outputs; nixosConfig = config; };
        # useGlobalPkgs = true;
        # useUserPackages = true;
  	users = {
  	  blusk = import ../../homes/blusk_workstation/home.nix;
  	};
  };

  users.mutableUsers = false;

  users.users.root.initialHashedPassword = "$6$1l3TCl1ZMdmM.SQx$pmpbS5C37.XMxMihuhMzZO5gso5IZh47NP6Dg61C.Eu1jHrA.rx4xgkFSHud.d3mxV6cJxQ3GH1ZKS/nLoFHt1";

  users.users = {
    blusk = {
      shell = pkgs.zsh;
      description = "mia";
      initialHashedPassword = "$6$1l3TCl1ZMdmM.SQx$pmpbS5C37.XMxMihuhMzZO5gso5IZh47NP6Dg61C.Eu1jHrA.rx4xgkFSHud.d3mxV6cJxQ3GH1ZKS/nLoFHt1";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "adbusers" "wireshark" "libvirtd" ];
    };
  };

  programs.light.enable = true;
  programs.adb.enable = true;

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      firefox = {
        executable = "${pkgs.firefox}/bin/firefox";
      };
    };
  };

  programs.fuse.userAllowOther = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

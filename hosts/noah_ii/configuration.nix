{ inputs, outputs, lib, config, pkgs, ... }:
let
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.impermanence.nixosModules.impermanence

    ./hardware-configuration.nix
    ../common/base_cli.nix
    ./gpu-passthrough.nix
  ];

  vfio.enable = true;

  specialisation."NOVFIO".configuration = {
    system.nixos.tags = [ "no-vfio" ];
    vfio.enable = lib.mkForce false;
    imports = [
      inputs.hardware.nixosModules.common-cpu-intel
      ./nvidia.nix
    ];
  };

  stylix.image = ./wallpaper.png;
  stylix.base16Scheme = ../../colors.yml;

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

  services.journald.extraConfig = "Storage=persistent";

  networking.hostName = "NoAH-II";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables.EDITOR = "nvim";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/home/blusk/.local/share/containers"
      "/etc/nixos"
      "/etc/NetworkManager"
      "/var/log"
      "/etc/mullvad-vpn"
      "/var/lib/libvirt"
      "/var/lib/containers"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  environment.systemPackages = [
    inputs.blusk-repo.packages."${pkgs.system}".xornet-reporter
  ];

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

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers = {
      registries.search = [ "docker.io" ];
    };
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
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
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

  programs.zsh.enable = true;

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

  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

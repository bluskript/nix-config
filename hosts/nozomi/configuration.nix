{ config, pkgs, lib, inputs, outputs, disko, ... }:
let
  blusk = import ../common/blusk.nix;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ../common/server.nix
    ./disks.nix
    ./conduit.nix
    ./filehost.nix
    ./nginx.nix
    # ./containers.nix
    ./rss-bridge.nix
  ];

  environment.noXlibs = true;

  networking.hostName = "nozomi";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
  users.users.root = {
    # nothing could hash to "!" so this disables root login
    hashedPassword = "!";
  };

  programs.zsh.enable = true;

  users.users.blusk = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    home = "/home/blusk";
    openssh.authorizedKeys.keys = [
      blusk.pubkey
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; nixosConfig = config; };
    # useGlobalPkgs = true;
    # useUserPackages = true;
    users = {
      blusk = import ../../homes/blusk_server/home.nix;
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  hardware.cpu.intel.updateMicrocode = true;

  system.activationScripts.createPersist = "mkdir -p /nix/persist";

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/private/matrix-conduit"
      "/var/lib/rss-bridge"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

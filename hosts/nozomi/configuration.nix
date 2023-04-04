{ config, pkgs, lib, inputs, disko, ... }:
let
  blusk = import ../common/blusk.nix;
in
  {
    imports = [
      inputs.impermanence.nixosModules.impermanence
      ../common/server.nix
      ../common/base_cli.nix
      ./disks.nix
      ./conduit.nix
      ./filehost.nix
      ./nginx.nix
    ];

    environment.noXlibs = true;

    networking.hostName = "nozomi";

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
    };

    security.sudo.wheelNeedsPassword = false;

    users.mutableUsers = false;
    users.users.root = {
      # nothing could hash to "!" so this disables root login
      hashedPassword = "!";
    };

    users.users.blusk = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      home = "/home/blusk";
      openssh.authorizedKeys.keys = [
        blusk.pubkey
      ];
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
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "22.11";
  }

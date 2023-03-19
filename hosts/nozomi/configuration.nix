{ config, pkgs, lib, ... }:
let
  blusk = import ../common/blusk.nix;
in
  {
    imports = [
      ../common/server.nix
      ../common/base_cli.nix
    ];

    networking.hostName = "nozomi";

    services.openssh.enable = true;

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
      version = 2;
      device = "/dev/vda";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/nozomi";
      fsType = "btrfs";
      option = [ "subvol=@boot" ];
    };

    hardware.cpu.intel.updateMicrocode = true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "22.11";
  }

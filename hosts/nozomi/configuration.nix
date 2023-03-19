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

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      system.stateVersion = "22.11";
  }

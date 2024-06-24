{
  pkgs,
  lib,
  inputs,
  ...
}: let
  blusk = import ../../identities/blusk.nix;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ../common/profiles/server.nix
  ];

  networking.hostName = "felys";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.root = {
    # nothing could hash to "!" so this disables root login
    hashedPassword = "!";
  };

  nix.settings.trusted-users = ["owner"];

  users.users.admin = {
    home = "/home/admin";
    createHome = true;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      blusk.pubkey
    ];
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        # runAsRoot = false;
        # Full is needed for TPM and secure boot emulation
        ovmf.packages = [pkgs.OVMFFull.fd];
        swtpm.enable = true;
        verbatimConfig = ''
          namespaces = []
          user = "owner"
          group = "libvirtd"
        '';
      };
    };
  };

  hardware.opengl.enable = true;

  services.openssh.enable = true;
  services.openssh.allowSFTP = true;

  services.journald.extraConfig = "Storage=persistent";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      {
        directory = "/etc/nixos";
        user = "owner";
      }
      "/etc/NetworkManager"
      "/var/log"
      "/var/lib/libvirt"
      "/var/lib/containers"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  programs.fuse.userAllowOther = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

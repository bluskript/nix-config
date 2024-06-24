{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  blusk = import ../../identities/blusk.nix;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ../common/profiles/server.nix
    ./disks.nix
  ];

  age.secrets.slskd-env.file = ../../secrets/slskd-env.age;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.slskd = {
    enable = true;
    openFirewall = true;
    domain = null;
    environmentFile = config.age.secrets.slskd-env.path;
    settings = {
      shares.directories = ["/nix/persist/music"];
      directories = {
        downloads = "/nix/persist/music/unsorted";
      };
    };
  };

  security.apparmor.enable = false;

  networking.hostName = "muse";
  nix.settings.trusted-users = ["blusk"];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    allowedTCPPorts = [22 80 443 8096 8920 564 5030];
    allowedUDPPorts = [1900 7359];
  };

  environment.systemPackages = [
    pkgs.picard
  ];

  environment.noXlibs = lib.mkForce false;

  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";
  # services.xrdp.openFirewall = true;

  services.openssh.enable = true;
  services.openssh.allowSFTP = true;

  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
  users.users.root = {
    # nothing could hash to "!" so this disables root login
    hashedPassword = "!";
  };

  programs.zsh.enable = true;

  users.users.blusk = {
    home = "/home/blusk";
    createHome = true;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
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

  system.activationScripts.createPersist = "mkdir -p /nix/persist";

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/jellyfin"
      "/var/lib/tailscale"
      "/var/lib/slskd"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

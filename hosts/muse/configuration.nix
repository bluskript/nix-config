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

  networking.hostName = "muse";
  nix.settings.trusted-users = ["blusk"];

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/music";
      Address = "0.0.0.0";
      Port = 4533;
      # EnableTranscodingConfig = true;
    };
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [22 80 443 4533];
    allowedUDPPortRanges = [];
  };

  environment.systemPackages = [
    pkgs.picard
  ];

  environment.noXlibs = lib.mkForce false;

  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";
  # services.xrdp.openFirewall = true;

  age.secrets.xornet.file = ../../secrets/nozomi-xornet.age;
  services.xornet-reporter.enable = lib.mkForce false;

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
      "/var/lib/private/navidrome"
      "/music"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

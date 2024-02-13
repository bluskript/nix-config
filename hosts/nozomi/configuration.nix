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
    ./conduit.nix
    ./filehost.nix
    ./nginx.nix
    # ./containers.nix
    ./rss-bridge.nix
    ./ff-sync.nix
    ./abletonzip.nix
    ./owncast.nix
    ./navidrome.nix
  ];

  nix.settings.trusted-users = [ "blusk" ];

  age.secrets.xornet.file = ../../secrets/nozomi-xornet.age;

  services.logrotate.checkConfig = false;

  networking.hostName = "nozomi";

  services.openssh.enable = true;
  services.openssh.allowSFTP = true;

  security.sudo.wheelNeedsPassword = false;

  # services.stalwart-mail = {
  #   enable = true;
  #   configFile = ./mail.toml;
  # };

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

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      nixosConfig = config;
    };
    # useGlobalPkgs = true;
    # useUserPackages = true;
    users = {
      blusk = (import ../../homes/blusk_server/home.nix);
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.cpu.intel.updateMicrocode = true;

  system.activationScripts.createPersist = "mkdir -p /nix/persist";

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/lib/private/matrix-conduit"
      "/var/lib/rss-bridge"
      "/var/lib/owncast"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

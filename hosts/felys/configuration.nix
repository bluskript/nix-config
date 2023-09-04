{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.hardware.nixosModules.common-pc-laptop-ssd

    ../common/profiles/desktop.nix
    ../felys/impermanence.nix
    ../felys/users.nix
    ../nozomi/stalwart-mail.nix
    ../noah_ii/firejail.nix
    ./passthrough.nix
    ./disks.nix
    ./bluetooth.nix

    ./hidden.nix
  ];

  work-mode.enable = false;
  
  # services.stalwart-mail = {
  #   enable = true;
  #   configFile = ../nozomi/mail.toml;
  # };

  networking.hostName = "felys";
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  stylix = let
    palette = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  in {
    base16Scheme = palette;
    image = (import ../common/stylix.nix {inherit pkgs;}).processWallpaper palette ../felys/wallpaper.png;
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      terminal = 0.8;
    };
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  services.openssh.enable = true;
  services.openssh.allowSFTP = true;

  # vfio.enable = true;
  # specialisation."NOVFIO".configuration = {
  #   system.nixos.tags = [ "no-vfio" ];
  #   vfio.enable = lib.mkForce false;
  #   imports = [
  #     inputs.hardware.nixosModules.common-cpu-intel
  #     ../noah_ii/nvidia.nix
  #   ];
  # };

  services.journald.extraConfig = "Storage=persistent";

  services.mullvad-vpn.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  programs.adb.enable = true;
  # for MTP
  services.gvfs.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      nixosConfig = config;
    };
    # useGlobalPkgs = true;
    # useUserPackages = true;
    users = {
      blusk = import ../../homes/blusk_workstation/home.nix;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-acpi_call

    ./hardware-configuration.nix
    ../common/profiles/desktop.nix
    ./users.nix
    ./impermanence.nix
    ./firejail.nix
    ./nvidia.nix
  ];

  work-mode.enable = true;

  age.secrets.xornet.file = ../../secrets/felys-xornet.age;
  age.identityPaths = ["/home/blusk/.ssh/id_ed25519"];

  networking.networkmanager = {
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "NoAH-II";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  stylix = let
    palette = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  in {
    base16Scheme = palette;
    image = (import ../common/stylix.nix {inherit pkgs;}).processWallpaper palette ../felys/wallpaper.png;
  };

  # services.snowflake-proxy = {
  #   enable = true;
  #   capacity = 100;
  # };
  #
  # services.tor = {
  #   enable = true;
  #   settings = {
  #     ServerTransportPlugin.transports = ["snowflake"];
  #   };
  # };

  # vfio.enable = true;
  # specialisation."NOVFIO".configuration = {
  #   system.nixos.tags = [ "no-vfio" ];
  #   vfio.enable = lib.mkForce false;
  #   imports = [
  #     inputs.hardware.nixosModules.common-cpu-intel
  #     ./nvidia.nix
  #   ];
  # };

  services.journald.extraConfig = "Storage=persistent";

  services.mullvad-vpn.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  programs.adb.enable = true;
  # for MTP
  services.gvfs.enable = true;
  services.udev.packages = [pkgs.heimdall];

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.hardware.nixosModules.common-pc-laptop-ssd

    ./hardware-configuration.nix
    ../common/profiles/desktop.nix
    ./users.nix
    ./impermanence.nix
    ./firejail.nix
    ./nvidia.nix
  ];

  networking.hostName = "NoAH-II";
  stylix.image = ./wallpaper.png;
  # stylix.base16Scheme = ../common/colors.yml;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

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
  services.udev.packages = [ pkgs.heimdall ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; nixosConfig = config; };
    # useGlobalPkgs = true;
    # useUserPackages = true;
    users = {
      blusk = import ../../homes/blusk_workstation/home.nix;
    };
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

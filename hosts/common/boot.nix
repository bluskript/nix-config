{ config, lib, ... }: with lib; {
  options = {
    systemdBoot = mkEnableOption "use systemd-boot" // {
      default = true;
    };
  };

  config = mkIf config.systemdBoot {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
  };
}

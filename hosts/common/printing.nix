{ lib, config, ... }: with lib; {
  options.printing = mkEnableOption "enable printing" // {
    default = config.computer.isLaptop;
  };

  config = mkIf config.printing {
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.avahi.openFirewall = true;
  };
}

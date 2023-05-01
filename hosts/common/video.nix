{ pkgs, lib, config, ... }: with lib; {
  options = {
    video = {
      enable = mkEnableOption "enable video stuff" // { default = true; };
      wayland = mkEnableOption "wayland" // { default = true; };
      sway = mkEnableOption "sway stuff" // { default = false; };
    };
  };

  config = let cfg = config.video; in
    mkIf cfg.enable {
      services.xserver = {
        layout = "us";
        xkbVariant = "";
      };
      hardware = {
        opengl = {
          enable = true;
          driSupport = true;
        };
      };
      xdg.portal = {
        enable = true;
        wlr.enable = cfg.wayland;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      programs.light.enable = config.computer.isLaptop;

      programs.sway.enable = cfg.sway;
    };
}

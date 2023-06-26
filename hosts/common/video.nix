{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib; {
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
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs.light.enable = true;

  programs.sway.enable = true;
  programs.sway.package = null;
}

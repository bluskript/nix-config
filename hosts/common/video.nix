{pkgs, ...}: {
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  hardware = {
    opengl = {
      enable = true;
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

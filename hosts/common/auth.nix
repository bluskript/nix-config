{ pkgs, lib, config, ... }: {
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}

{pkgs, ...}: {
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.udev.packages = [pkgs.yubikey-personalization];
  security.pam.u2f = {
    control = "sufficient";
    cue = true;
    appId = "pam://$HOSTNAME [cue_prompt=🔐 Enter your yubikey]";
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}

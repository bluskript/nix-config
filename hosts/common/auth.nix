{ pkgs, lib, config, ... }: with lib; {
  options = {
    auth = {
      yubikey = mkEnableOption "yubikey authentication";
      gpg = mkEnableOption "gpg agent";
    };
  };

  config = let cfg = config.auth; in
    mkMerge [
      (mkIf cfg.gpg
        {
          programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
          };
        })
      (mkIf cfg.yubikey {
        services.udev.packages = [ pkgs.yubikey-personalization ];
        security.pam.services = {
          login.u2fAuth = true;
          sudo.u2fAuth = true;
        };
      })
    ];
}

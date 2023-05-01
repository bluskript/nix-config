{ lib, config, ... }: with lib; {
  options = {
    ssh = {
      disableBloatware = mkEnableOption "disable everything except publickey authentication";
    };
  };
  config =
    let
      cfg = config.ssh; in
    {
      services.openssh = mkMerge [
        {
          settings = {
            PasswordAuthentication = false;
          };
          allowSFTP = false;
        }
        (mkIf cfg.disableBloatware {
          # TODO: figure out why RHEL disables this
          challengeResponseAuthentication = false;
          # disable unnecessary features
          extraConfig = ''
            			AllowTcpForwarding yes
            			X11Forwarding no
            			AllowAgentForwarding no
            			AllowStreamLocalForwarding no
            			AuthenticationMethods publickey
            		'';
        })
      ];
    };
}

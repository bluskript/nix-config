{ lib, config, ... }: with lib; {
  services.openssh =
    {
      settings = {
        PasswordAuthentication = false;
      };
      allowSFTP = mkDefault false;
      # TODO: figure out why RHEL disables this
      settings = {
        KbdInteractiveAuthentication = false;
      };
      # disable unnecessary features
      extraConfig = ''
        			AllowTcpForwarding yes
        			X11Forwarding no
        			AllowAgentForwarding no
        			AllowStreamLocalForwarding no
        			AuthenticationMethods publickey
        		'';
    };
}

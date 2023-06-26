{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      {
        directory = "/etc/nixos";
        user = "blusk";
      }
      "/etc/NetworkManager"
      "/var/log"
      "/etc/mullvad-vpn"
      "/var/lib/libvirt"
      "/var/lib/containers"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  programs.fuse.userAllowOther = true;
}

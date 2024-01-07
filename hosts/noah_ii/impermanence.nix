{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager"
      "/var/log"
      "/etc/mullvad-vpn"
      "/var/lib/libvirt"
      "/var/lib/containers"
      "/etc/tailord"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  programs.fuse.userAllowOther = true;
}

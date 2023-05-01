{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/home/blusk/.local/share/containers"
      "/etc/nixos"
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

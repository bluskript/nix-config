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
      {
        directory = "/etc/wireguard";
        mode = "u+rw,g=,o=";
        user = "root";
        group = "root";
      }
      "/var/lib/libvirt"
      "/var/lib/containers"
      "/var/lib/thelounge/users"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/OpenRGB/sizes.ors"
    ];
  };

  programs.fuse.userAllowOther = true;
}

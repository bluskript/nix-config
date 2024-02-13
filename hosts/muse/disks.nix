{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/nix/persist/music" = {
    fsType = "fuse";
    device = "${pkgs.sshfs-fuse}/bin/sshfs#muse@10.9.1.16:/";
    options = [
      "noauto"
      "_netdev"
      "allow_other"
      "reconnect"
      "follow_symlinks"
      "x-systemd.automount"
      "StrictHostKeyChecking=no"
      "UserKnownHostsFile=/dev/null"
      "ServerAliveInterval=10"
      "IdentityFile=/etc/ssh/ssh_host_ed25519_key"
      "port=2022"
    ];
  };
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"
        "mode=755"
      ];
    };
    disk.sda = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "boot";
            start = "0";
            end = "1M";
            flags = ["bios_grub"];
          }
          {
            name = "ESP";
            start = "1MiB";
            end = "512MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "persist";
            start = "512MiB";
            end = "100%";
            part-type = "primary";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
            };
          }
        ];
      };
    };
  };
}

{
  disko,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usbhid"];
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
  boot.initrd.luks.devices.cryptroot.allowDiscards = true;
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=8G"
        "defaults"
        "mode=755"
      ];
    };
    disk.nvme0n1 = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "100MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          }
          {
            name = "luks";
            start = "100MiB";
            end = "100%";
            part-type = "primary";
            content = {
              type = "luks";
              name = "cryptroot";
              keyFile = "/tmp/secret.key";
              content = {
                type = "btrfs";
                subvolumes = {
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime" "discard=async"];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "noatime" "discard=async"];
                  };
                };
              };
            };
          }
        ];
      };
    };
  };
}

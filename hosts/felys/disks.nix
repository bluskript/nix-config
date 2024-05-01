{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usbhid"];
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
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
        type = "gpt";
        partitions = {
          ESP = {
            label = "ESP";
            type = "EF00";
            size = "100M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          };
          luks = {
            label = "luks";
            start = "100MiB";
            end = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              passwordFile = "/tmp/secret.key";
              settings = {
                allowDiscards = true;
              };
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
          };
        };
      };
    };
  };
}

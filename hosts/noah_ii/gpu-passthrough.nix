# REFERENCES
# ---
# Originally based off of:
# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
# Borrowing fancier stuff from:
# https://github.com/chayleaf/dotfiles/blob/3c2e6ab8b9ec0cb638f9a61b4f35daaa2b7912bd/system/common/vfio.nix
# And of course, you can't forget the sacred texts:
# https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
#
# Hmm... someone should make a common way to configure VFIO in nixos options or smth...
# There's a lot of different setups so it seems difficult... but it should be possible.
{
  pkgs,
  pkgsUnstable,
  lib,
  config,
  ...
}: {
  options.vfio = with lib; {
    enable = mkEnableOption "Configure the machine for VFIO";
    ids = mkOption {
      type = types.listOf types.string;
      default = [];
    };
  };

  config = let
    cfg = config.vfio;
  in
    lib.mkIf cfg.enable {
      boot = {
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          "vfio_virqfd"
          "kvmfr"
        ];

        extraModulePackages = [
          config.boot.kernelPackages.kvmfr
        ];

        blacklistedKernelModules = ["nouveau"];

        kernelParams = [
          # enable IOMMU
          "intel_iommu=on"
          "iommu=pt"
          # potential workaround: echo "efi-framebuffer.0" > /sys/bus/platform/devices/efi-framebuffer.0/driver/unbind
          "video=efifb:off"
          ("vfio-pci.ids=" + lib.concatStringsSep "," passthroughIDs)
        ];
      };

      hardware.opengl.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          ovmf.enable = true;
          # Full is needed for TPM and secure boot emulation
          ovmf.packages = [pkgs.OVMFFull.fd];
          swtpm.enable = true;
        };
      };

      virtualisation.kvmfr = {
        enable = true;
        devices = [
          {
            dimensions = {
              width = 3840;
              height = 2160;
            };
            permissions = {
              group = "libvirtd";
              mode = "0660";
            };
          }
        ];
      };

      environment.systemPackages = with pkgs.unstable; [
        virt-manager
      ];

      # virt-manager saves settings here
      programs.dconf.enable = true;
    };
}

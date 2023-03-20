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
let
  gpuIDs = [
    "10de:2520" # Graphics
    "10de:228e" # Audio
  ];
in { pkgs, pkgsUnstable, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = [
        # enable IOMMU
        "intel_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        # Full is needed for TPM and secure boot emulation
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    environment.systemPackages = with pkgs.unstable; [
      virt-manager
    ];

    # virt-manager saves settings here
    programs.dconf.enable = true;

    systemd.tmpfiles.rules = [
      "f	/dev/shm/looking-glass	0660	blusk		qemu-libvirtd	-"
    ];
  };
}

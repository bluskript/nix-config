{ pkgs, ... }: {
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        # runAsRoot = false;
        # Full is needed for TPM and secure boot emulation
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        swtpm.enable = true;
        verbatimConfig = ''
          namespaces = []
          user = "blusk"
          group = "libvirtd"
        '';
      };
    };
    vfio = {
      enable = true;
      IOMMUType = "amd";
      devices = [
        "10de:2203" # GPU
        "10de:1aef" # audio controller
      ];
      blacklistNvidia = true;
      ignoreMSRs = false;
      applyACSpatch = false;
      disableEFIfb = false;
    };
    kvmfr = {
      enable = true;
      devices = [
        {
          dimensions = {
            width = 3840;
            height = 2160;
          };
          permissions = {
            user = "blusk";
            group = "libvirtd";
            mode = "0660";
          };
        }
      ];
    };
  };

  hardware.opengl.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  # virt-manager saves settings here
  programs.dconf.enable = true;
}

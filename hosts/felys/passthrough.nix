{ pkgs, ... }:
let
  startVM = pkgs.writeScriptBin "startVM" ''
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
    virsh start $1
  '';
  stopVM = pkgs.writeScriptBin "stopVM" ''
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
    virsh shutdown $1
  '';
in
{
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
      ignoreMSRs = true;
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
  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.virtiofsd
    startVM
    stopVM
  ];
  # virt-manager saves settings here
  programs.dconf.enable = true;
}

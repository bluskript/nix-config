{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.nvidia.enable = lib.mkEnableOption "enable nvidia offloading";

  imports = [inputs.hardware.nixosModules.common-gpu-nvidia];

  config = {
    environment.systemPackages = [nvidia-offload];

    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.prime = {
      offload.enable = true;
      intelBusId = "PCI:01:00:0";
      nvidiaBusId = "PCI:00:02:0";
    };
  };
}

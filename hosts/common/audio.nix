{ lib, config, ... }: with lib; {
  options.audio = mkEnableOption "audio support" // {
    default = config.computer.isLaptop;
  };

  config = mkIf config.audio {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}

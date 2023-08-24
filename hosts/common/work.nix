{lib, config, ...}:
with lib; {
  options = {
    work-mode.enable = mkEnableOption "Enable Work Mode";
  };
  config = mkIf config.work-mode.enable {
    networking.hosts = {
      "255.255.255.255" = ["discord.com" "twitter.com" "youtube.com"];
    };
  };
}

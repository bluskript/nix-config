{
  config,
  pkgs,
  ...
}: let
  scheme = config.lib.stylix.colors {template = builtins.readFile ./default.mustache;};
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    settings = {
      mainBar = let
        offsetY = {
          offset ? "1",
          size ? "medium",
          icon,
        }: "<span rise='${offset}pt' size='${size}'>${icon}</span>";
        offsetNerdIcon = icon:
          offsetY {icon = icon;};
      in {
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["sway/window"];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "network"
          "tray"
          "clock"
        ];
        tray = {
          spacing = 10;
        };
        "clock" = {
          interval = 1;
          format = "{:%Y-%m-%d | %H:%M:%OS}";
        };
        memory = {
          format = " {}%";
        };
        cpu = {
          format = " {}%";
        };
        network = let
          upDownFormat = "↑ {bandwidthUpBits} │ ↓ {bandwidthDownBits}";
        in {
          interval = 1;
          formatWifi = " {essid} ({signalStrength}%) :: ${upDownFormat}";
          formatEthernet = "  {ifname}: {ipaddr}/{cidr} :: ${upDownFormat}";
          format = "{ifname} :: ${upDownFormat}";
          formatDisconnected = "⚠  Disconnected";
          tooltipFormat = "{ifname}: {ipaddr}";
        };
        sway = {
          mode = {
            format = "<span style=\"italic\">  {}</span>";
          };
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            headphones = offsetNerdIcon "";
            handsfree = offsetNerdIcon "";
            headset = offsetNerdIcon "";
            phone = offsetNerdIcon "";
            portable = offsetNerdIcon "";
            car = offsetNerdIcon "";
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };
        services.temperature = {
          enable = true;
          criticalThreshold = 80;
          interval = 5;
          format = "{icon}  {temperatureC}°C";
          formatIcons = builtins.map (x: offsetNerdIcon x) [
            "" # Icon: temperature-empty
            "" # Icon: temperature-quarter
            "" # Icon: temperature-half
            "" # Icon: temperature-three-quarters
            "" # Icon: temperature-full
          ];
          tooltip = true;
        };
        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "${offsetNerdIcon ""}  {icon}  {capacity}%";
          formatDischarging = "{icon}  {capacity}%";
          formatIcons = builtins.map (x: offsetNerdIcon x) [
            "" # Icon: battery-full
            "" # Icon: battery-three-quarters
            "" # Icon: battery-half
            "" # Icon: battery-quarter
            "" # Icon: battery-empty
          ];
          tooltip = true;
        };
      };
    };
    style = ''
      @import "${scheme}";
      ${builtins.readFile ./style.css}
    '';
  };
}

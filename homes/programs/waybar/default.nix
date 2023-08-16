{config, ...}: let
  scheme = config.lib.stylix.colors {template = builtins.readFile ./default.mustache;};
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    settings = {
      mainBar = {
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
          "clock#date"
          "clock#time"
        ];
        "clock#time" = {
          interval = 1;
          format = "{:%H:%M:%S}";
        };
        network = {
          interval = 5;
          formatWifi = "  {essid} ({signalStrength}%)";
          formatEthernet = "  {ifname}: {ipaddr}/{cidr}";
          formatDisconnected = "⚠  Disconnected";
          tooltipFormat = "{ifname}: {ipaddr}";
        };
        sway = {
          mode = {
            format = "<span style=\"italic\">  {}</span>"; # Icon: expand-arrows-alt
          };
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };
        services.temperature = {
          enable = true;
          criticalThreshold = 80;
          interval = 5;
          format = "{icon}  {temperatureC}°C";
          formatIcons = [
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
          format = "  {icon}  {capacity}%";
          formatDischarging = "{icon}  {capacity}%";
          formatIcons = [
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

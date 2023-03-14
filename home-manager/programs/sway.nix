{ config, lib, pkgs, ... }: {
  imports = [
  ];
  home.sessionVariables = {
    WLR_DRM_NO_MODIFIERS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi --show run";
      gaps = {
        inner = 8;
      };
      input = {
        "type:keyboard" = {
          # xkb_layout = config.services.xserver.layout;
        };
        "type:pointer" = {
          accel_profile = "flat";
        };
        "type:touchpad" = {
          accel_profile = "adaptive";
          tap = "enabled";
          scroll_method = "two_finger";
          dwt = "enabled";
        };
      };
      output = {
        eDP-1 = {
          scale = "1";
          pos = "0 0";
          resolution = "1920x1080";
        };
        DP-1 = {
          scale = "1";
          pos = "1920 0";
          resolution = "3480x2160";
        };
      };
      keybindings = let 
        cfg = config.wayland.windowManager.sway.config;
        mod = cfg.modifier;
      in lib.mkOptionDefault rec {
          "${mod}+space" = "exec ${cfg.menu}";
          #"${mod}+Return" = "exec $(cfg.terminal)";
          "${mod}+w" = "kill";
          "${mod}+s" = "floating toggle";
          "XF86AudioRaiseVolume" = "pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "pactl set-sink-mute 0 toggle";
          "XF86AudioPlay" = "playerctl play-pause";
          "XF86AudioPrev" = "playerctl previous";
          "XF86AudioNext" = "playerctl next";
          "XF86AudioStop" = "playerctl stop";
          "XF86MonBrightnessUp" = "light -T 1.4";
          "XF86MonBrightnessDown" = "light -T 0.72";
        };
    };
  };
}

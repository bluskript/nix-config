{ config, lib, inputs, pkgs, ... }:
let
  lock = pkgs.writeShellScript "lock" "${pkgs.swaylock}/bin/swaylock -fF";
in
{
  imports = [
    ../waybar
  ];

  home.packages = with pkgs; [
    wofi
    wl-clipboard
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

  services.mako = {
    enable = true;
    anchor = "bottom-right";
  };

  programs.swaylock = {
    enable = true;
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 60; command = "exec ${lock}"; }
    ];
  };

  programs.wlogout = {
    enable = true;
  };

  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty msg create-window || alacritty";
      menu = "wofi --show run";
      bars = [ ];
      gaps = {
        inner = 8;
      };
      floating.criteria = [
        { app_id = "virt-manager"; }
      ];
      input = {
        "type:keyboard" = {
          xkb_options = "caps:escape";
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
      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
          mod = cfg.modifier;
        in
        lib.mkOptionDefault rec {
          "${mod}+space" = "exec ${cfg.menu}";
          #"${mod}+Return" = "exec $(cfg.terminal)";
          "${mod}+w" = "kill";
          "${mod}+s" = "floating toggle";
          "${mod}+t" = "layout tabbed";
          "${mod}+d" = "layout stacking";
          # screenshot to clipboard
          "Print" = "exec slurp | grim -g - - | wl-copy -t image/png";
          # upload screenshot
          "Shift+Print" = "exec slurp | grim -g - - | curl --form 'file=@-' http://0x0.st | wl-copy";
          # color picker
          "${mod}+p" = "exec slurp -p | grim -g - -t ppm - | ${pkgs.imagemagick}/bin/convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | wl-copy";
          "ctrl+alt+l" = "exec ${lock}";
          "${mod}+ctrl+l" = "exec ${pkgs.wlogout}/bin/wlogout";
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
    extraConfigEarly = ''
      default_dim_inactive 0.1
      corner_radius 4
      smart_corner_radius enable
    '';
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
}

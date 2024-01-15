{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  lock = pkgs.writeShellScript "lock" "${pkgs.swaylock}/bin/swaylock -fF";
in {
  home.packages = with pkgs; [
    wl-clipboard
    wtype
    wofi-emoji
    wofi
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
    events = [
      {
        event = "before-sleep";
        command = "exec ${lock}";
      }
    ];
    # timeouts = [
    #   {
    #     timeout = 60;
    #     command = "exec ${lock}";
    #   }
    # ];
  };

  programs.wlogout = {
    enable = true;
  };

  wayland.windowManager.sway = {
    package = inputs.swayfx.packages.${pkgs.system}.default;
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty msg create-window || alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show run";
      bars = [];
      fonts = {
        names = pkgs.lib.mkBefore [ "Cozette" ];
        size = 10.0;
      };
      # gaps = {
      #   inner = 8;
      # };
      floating.criteria = [
        {app_id = "virt-manager";}
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
      keybindings = let
        cfg = config.wayland.windowManager.sway.config;
        mod = cfg.modifier;
        wlogout = "${pkgs.wlogout}/bin/wlogout";
        imagemagick = pkgs.imagemagick;
        pactl = "${pkgs.pulseaudioFull}/bin/pactl";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        light = "${pkgs.light}/bin/light";
        grim = "${pkgs.grim}/bin/grim";
        slurp = "${pkgs.slurp}/bin/slurp";
        imv = "${pkgs.imv}/bin/imv";
        wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
        jq = "${pkgs.jq}/bin/jq";
        currentoutput = "${pkgs.sway}/bin/swaymsg -t get_outputs | ${jq} -r '.[] | select(.focused) | .name'";
        tesseract = "${pkgs.tesseract}/bin/tesseract";
        screenshot =
          pkgs.writeShellScript "screenshot"
          ''
            ${grim} -o "$(${currentoutput})" - | (${imv} -f - &)
            ID=$!
            ${slurp} | ${grim} -g - - | ${wl-copy} -t image/png
            kill $ID
          '';
        forceKill = pkgs.writeShellScript "forcekill" ''
          kill -9 $(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')
        '';
      in
        lib.mkOptionDefault {
          "${mod}+space" = "exec ${cfg.menu}";
          #"${mod}+Return" = "exec $(cfg.terminal)";
          "${mod}+w" = "kill";
          "${mod}+shift+w" = "exec ${forceKill}";
          "${mod}+s" = "floating toggle";
          "${mod}+t" = "layout tabbed";
          "${mod}+d" = "layout stacking";
          "${mod}+e" = "exec wofi-emoji";
          # screenshot to clipboard, freeze frame
          "Print" = "exec ${screenshot}";
          # screenshot to clipboard, no freeze frame
          "Ctrl+Print" = "exec ${slurp} | ${grim} -g - - | ${wl-copy} -t image/png";
          # OCR
          "Shift+Print" = "exec ${slurp} | ${grim} -g - - | ${tesseract} stdin stdout -l eng | wl-copy";
          # color picker
          "${mod}+p" = "exec ${slurp} -p | ${grim} -g - -t ppm - | ${imagemagick}/bin/convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | wl-copy";
          "ctrl+alt+l" = "exec ${lock}";
          "${mod}+ctrl+l" = "exec ${wlogout}";
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume 0 -5%";
          "XF86AudioMute" = "exec ${pactl} set-sink-mute 0 toggle";
          "XF86AudioPlay" = "exec ${playerctl} play-pause";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioStop" = "exec ${playerctl} stop";
          "XF86MonBrightnessUp" = "exec ${light} -T 1.4";
          "XF86MonBrightnessDown" = "exec ${light} -T 0.72";
        };
    };
    extraConfigEarly = ''
      default_dim_inactive 0.1
      corner_radius 4
      smart_corner_radius enable

      for_window [class="REAPER" title="FX:.*"] floating enable
      for_window [class="REAPER" title="(LV2i?|VST3?i?|JS):.*"] floating enable
      for_window [class="REAPER" title="Add FX.*"] floating enable, resize set height 800
      for_window [class="REAPER" title="Insert Virtual Instrument on New Track.*"] floating enable, resize set height 800
      for_window [class="REAPER" title="Media Item Properties:.*"] floating enable, resize set width 600
      for_window [class="REAPER" title="MIDI take:.*"] floating enable
      for_window [app_id="imv"] floating enable
      for_window [app_id="mpv"] floating enable
    '';
    extraOptions = [
      "--unsupported-gpu"
    ];
  };
}

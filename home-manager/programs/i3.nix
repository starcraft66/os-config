{ config, lib, pkgs, ... }:

let
  dpi = 144;
  theme = {
    color0 = "#1d1f21";
    color1 = "#282a2e";
    color2 = "#373b41";
    color3 = "#969896";
    color4 = "#b4b7b4";
    color5 = "#c5c8c6";
    color6 = "#e0e0e0";
    color7 = "#ffffff";
    color8 = "#cc6666";
    color9 = "#de935f";
    colorA = "#f0c674";
    colorB = "#b5bd68";
    colorC = "#8abeb7";
    colorD = "#81a2be";
    colorE = "#b294bb";
    colorF = "#a3685a";
  };
in
{
  programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      output_format = "i3bar";
      colors = "false";
      markup = "pango";
      color_good = "#2f343f";
      color_degraded = "#ebcb8b";
      color_bad = "#ba5e57";
    };
    modules = {
      "load" = {
        position = 1;
        settings = {
          format = "<span background='#f59335'>  %5min Load </span>";
        };
      };
      "disk /" = {
        position = 2;
        settings = {
          format = "<span background='#fec7cd'>  %free Free </span>";
        };
      };
      "ethernet Home@enp3s0" = {
        position = 3;
        settings = {
          format_up = "<span background='#88c0d0'> ﯱ %ip </span>";
          format_down = "<span background='#88c0d0'>  Disconnected </span>";
        };
      };
      "volume master" = {
        position = 4;
        settings = {
          format = "<span background='#ebcb8b'>  %volume </span>";
          format_muted = "<span background='#ebcb8b'> ﱝ Muted </span>";
          device = "default";
          mixer = "Master";
          mixer_idx = 0;
        };
      };
      "tztime local" = {
        position = 5;
        settings = {
          format = "<span background='#81a1c1'> %time </span>";
          format_time = " %a %-d %b %H:%M";
        };
      };
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        #font = "MesloLGS Nerd Font 10";
        markup = "full";
        format = "<b>%a</b>\\n<b>%s</b>\\n%b";
        sort = "no";
        indicate_hidden = "yes";
        alignment = "center";
        bounce_freq = 0;
        show_age_threshold = -1;
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = "yes";
        hide_duplicate_count = "yes";
        geometry = "300x50-15+49";
        shrink = "no";
        transparency = 5;
        idle_threshold = 0;
        monitor = 0;
        follow = "none";
        sticky_history = "yes";
        history_length = 15;
        show_indicators = "no";
        line_height = 3;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "frame";
        startup_notification = "false";
        dmenu = "${pkgs.rofi}/bin/rofi -p dunst -dmenu";
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        icon_position = "off";
        max_icon_size = 80;
        #icon_path = /usr/share/icons/Paper/16x16/mimetypes/:/usr/share/icons/Paper/48x48/status/:/usr/share/icons/Paper/16x16/devices/:/usr/share/icons/Paper/48x48/notifications/:/usr/share/icons/Paper/48x48/emblems/;
        frame_width = 3;
        frame_color = "#8EC07C";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        frame_color = "#3B7C87";
        foreground = "#3B7C87";
        background = "#191311";
        timeout = 8;
      };
      urgency_normal = {
        frame_color = "#5B8234";
        foreground = "#5B8234";
        background = "#191311";
        timeout = 8;
      };
      urgency_critical = {
        frame_color = "#B7472A";
        foreground = "#B7472A";
        background = "#191311";
        timeout = 8;
      };
    };
  };

  xdg.configFile."rofi/flat-orange.rasi".text = ''
    /**
    * ROFI Color theme
    * User: mbfraga
    * Copyright: Martin B. Fraga
    */

    /* global settings and color variables */
    * {
      maincolor:        #ed8712;
      highlight:        bold #ed8712;
      urgentcolor:      #e53714;

      fgwhite:          #cfcfcf;
      blackdarkest:     #1d1d1d;
      blackwidget:      #262626;
      blackentry:       #292929;
      blackselect:      #303030;
      darkgray:         #848484;
      scrollbarcolor:   #505050;
      font: "MesloLGS Nerd Font Mono 10";
      background-color: @blackdarkest;
    }

    window {
      background-color: @blackdarkest;
      anchor: north;
      location: north;
      y-offset: 20%;
    }

    mainbox {
      background-color: @blackdarkest;
      spacing:0px;
      children: [inputbar, message, mode-switcher, listview];
    }

    message {
      padding: 6px 10px;
      background-color:@blackwidget;
    }

    textbox {
      text-color:@darkgray;
      background-color:@blackwidget;
    }

    listview {
      fixed-height: false;
      dynamic: true;
      scrollbar: true;
      spacing: 0px;
      padding: 1px 0px 0px 0px;
      margin: 0px 0px 1px 0px;
      background: @blackdarkest;
    }

    element {
      padding: 2px 15px;
    }

    element normal.normal {
      padding: 0px 15px;
      background-color: @blackentry;
      text-color: @fgwhite;
    }

    element normal.urgent {
      background-color: @blackentry;
      text-color: @urgentcolor;
    }

    element normal.active {
      background-color: @blackentry;
      text-color: @maincolor;
    }

    element selected.normal {
        background-color: @blackselect;
        text-color:       @fgwhite;
    }

    element selected.urgent {
        background-color: @urgentcolor;
        text-color:       @blackdarkest;
    }

    element selected.active {
        background-color: @maincolor;
        text-color:       @blackdarkest;
    }

    element alternate.normal {
        background-color: @blackentry;
        text-color:       @fgwhite;
    }

    element alternate.urgent {
        background-color: @blackentry;
        text-color:       @urgentcolor;
    }

    element alternate.active {
        background-color: @blackentry;
        text-color:       @maincolor;
    }

    scrollbar {
      background-color: @blackwidget;
      handle-color: @darkgray;
      handle-width: 15px;
    }

    mode-switcher {
      background-color: @blackwidget;
    }

    button {
      background-color: @blackwidget;
      text-color:       @darkgray;
    }

    button selected {
        text-color:       @maincolor;
    }

    inputbar {
      background-color: @blackdarkest;
      spacing: 0px;
    }

    prompt {
      padding:6px 9px;
      background-color: @maincolor;
      text-color:@blackwidget;
    }

    entry {
      padding:6px 10px;
      background-color:@blackwidget;
      text-color:@fgwhite;
    }

    case-indicator {
      padding:6px 10px;
      text-color:@maincolor;
      background-color:@blackwidget;
    }
    '';

  programs.rofi = {
    enable = true;
    separator = "solid";
    font = "MesloLGS Nerd Font Mono 10";
    theme = "${config.xdg.configHome}/rofi/flat-orange.rasi";
    # colors = {
    #   window = {
    #     background = theme.color1;
    #     border = theme.color1;
    #     separator = theme.color0;
    #   };
    #   rows = {
    #     normal = {
    #       background = theme.color1;
    #       foreground = theme.color5;
    #       backgroundAlt = theme.color1;
    #       highlight = {
    #         background = theme.color1;
    #         foreground = theme.color7;
    #       };
    #     };
    #     active = {
    #       background = theme.color1;
    #       foreground = theme.colorD;
    #       backgroundAlt = theme.color1;
    #       highlight = {
    #         background = theme.color1;
    #         foreground = theme.colorD;
    #       };
    #     };
    #     urgent = {
    #       background = theme.color1;
    #       foreground = theme.color8;
    #       backgroundAlt = theme.color1;
    #       highlight = {
    #         background = theme.color1;
    #         foreground = theme.color8;
    #       };
    #     };
    #   };
    # };
    extraConfig = ''
      rofi.dpi: 0
    '';
  };

  services.picom = {
    backend = "xrender";
  };

  xsession.windowManager.i3 = rec {
    enable = true;
    # package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      bars = [
        {
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = config.fonts;
          trayOutput = "DP-4";
          position = "top";
          colors = {
            background = theme.color1;
            statusline = theme.color1;
            separator = "#515151";
            focusedWorkspace = {
              border = theme.colorD;
              background = theme.colorD;
              text = theme.color0;
            };
            activeWorkspace = {
              border = "#333333";
              background = "#333333";
              text = theme.colorF;
            };
            inactiveWorkspace = {
              border = theme.color1;
              background = theme.color1;
              text = "#999999";
            };
            urgentWorkspace = {
              border = theme.color8;
              background = theme.color8;
              text = theme.colorF;
            };
          };
        }
      ];
      colors = {
        focused = {
          border = theme.colorD;
          childBorder = theme.colorD;
          background = theme.colorD;
          text = theme.color0;
          indicator = theme.color1;
        };
        focusedInactive = {
          border = theme.color2;
          childBorder = theme.color2;
          background = theme.color2;
          text = theme.color3;
          indicator = "#292d2e";
        };
        unfocused = {
          border = theme.color1;
          childBorder = theme.color1;
          background = theme.color1;
          text = "#999999";
          indicator = "#292d2e";
        };
        urgent= {
          border = "#2f343a";
          childBorder = "#2f343a";
          background = theme.color8;
          text = theme.colorF;
          indicator = theme.color8;
        };
      };
      fonts = [
        "pango:MesloLGS Nerd Font Mono 10"
      ];
      workspaceAutoBackAndForth = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      startup = [
        { command = "pkill picom; ${pkgs.picom}/bin/picom --backend xrender --xrender-sync-fence --no-vsync"; notification = false; }
        { command = "pkill ckb-next; ${pkgs.ckb-next}/bin/ckb-next --background"; notification = false; }
        { command = "pkill xsecurelock; ${pkgs.xss-lock}/bin/xss-lock ${pkgs.coreutils}/bin/env XSECURELOCK_PASSWORD_PROMPT=time_hex XSECURELOCK_NO_COMPOSITE=1 XSECURELOCK_BLANK_DPMS_STATE=off XSECURELOCK_BLANK_TIMEOUT=30 ${pkgs.xsecurelock}/bin/xsecurelock"; notification = false; }
        # { command = "pkill dunst; ${pkgs.dunst}/bin/dunst"; notification = false; }
      ];
      keybindings = let mod = config.modifier; in {
        "${mod}+a" = "exec ${config.menu}";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
        "Mod1+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${mod}+Return" = "exec ${config.terminal}";
        "${mod}+w" = "exec chromium";
        "${mod}+e" = "exec thunar";
        "${mod}+q" = "exec dmenu_run";
        "${mod}+Print" = "exec flameshot gui";
        "${mod}+Shift+q" = "kill";

        "${mod}+r" = "mode resize";
        "${mod}+Shift+grave" = "move scratchpad";
        "${mod}+grave" = "scratchpad show";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+minus" = "split v";
        "${mod}+Shift+bar" = "split h";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+s" = "layout stacking";
        "${mod}+Shift+t" = "layout tabbed";
        "${mod}+Shift+f" = "floating toggle";
        "${mod}+Space" = "focus mode_toggle";
        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";
        "${mod}+0" = "workspace 10";
        "${mod}+Shift+1" = "move container to workspace 1";
        "${mod}+Shift+2" = "move container to workspace 2";
        "${mod}+Shift+3" = "move container to workspace 3";
        "${mod}+Shift+4" = "move container to workspace 4";
        "${mod}+Shift+5" = "move container to workspace 5";
        "${mod}+Shift+6" = "move container to workspace 6";
        "${mod}+Shift+7" = "move container to workspace 7";
        "${mod}+Shift+8" = "move container to workspace 8";
        "${mod}+Shift+9" = "move container to workspace 9";
        "${mod}+Shift+0" = "move container to workspace 10";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";

        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";

        "XF86MonBrightnessUp" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 5";
        "XF86MonBrightnessDown" = "exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 5";

        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
      };
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize shrink height 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
  };

  xresources.properties = {
    "xft.dpi" = dpi;
  };
}

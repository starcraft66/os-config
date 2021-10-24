{ config, lib, pkgs, ... }:

let
 inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
 originalConfig = config;
in
(lib.mkIf isLinux {
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
            format = "{1m}";
          }
          { block = "sound"; }
          {
            block = "time";
            interval = 1;
            format = "%a %d/%m %R";
          }
        ];
        icons = "none";
        theme = "space-villain";
      };
    };
  };

  services.dunst.package = pkgs.dunst.overrideAttrs (old: rec {
    version = "1.7.0";
    src = pkgs.fetchFromGitHub {
      owner = "dunst-project";
      repo = "dunst";
      rev = "v${version}";
      # hash = "${lib.fakeHash}";
      hash = "sha256-BWbvGetXXCXbfPRY+u6gEfzBmX8PLSnI6a5vfCByiC0=";
    };
  });

  services.dunst = {
    enable = true;
    settings = {
      global = {
        #font = "MesloLGS Nerd Font 10";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        sort = false;
        indicate_hidden = true;
        alignment = "left";
        vertical_alignment = "top";
        bounce_freq = 0;
        show_age_threshold = -1;
        word_wrap = true;
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = true;
        origin = "top-center";
        shrink = false;
        transparency = 3;
        idle_threshold = 0;
        monitor = 0;
        follow = "none";
        sticky_history = true;
        history_length = 15;
        show_indicators = false;
        line_height = 3;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "frame";
        startup_notification = false;
        dmenu = "${pkgs.rofi}/bin/rofi -p dunst -dmenu";
        browser = "${pkgs.firefox}/bin/firefox --new-tab";
        icon_position = "left";
        max_icon_size = 64;
        frame_width = 2;
        frame_color = originalConfig.my.theme.color5;
        font = "Sans 10";
        corner_radius = 2;
        height = "150";
        width = "350";
        offet = "0x60";
        ellipsize = "end";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        frame_color = originalConfig.my.theme.color5;
        foreground = originalConfig.my.theme.color4;
        background = originalConfig.my.theme.color1;
        timeout = 8;
      };
      urgency_normal = {
        frame_color = originalConfig.my.theme.color5;
        foreground = originalConfig.my.theme.color4;
        background = originalConfig.my.theme.color1;
        timeout = 8;
      };
      urgency_critical = {
        frame_color = originalConfig.my.theme.color5;
        foreground = originalConfig.my.theme.color4;
        background = originalConfig.my.theme.color1;
        timeout = 8;
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "128x128";
    };
  };

  home.packages = with pkgs; [
    tint2
    xss-lock
    xsecurelock
  ];

  xdg.configFile."tint2/tint2rc".text = ''
    # Background 1: Active task
    rounded = 10
    border_width = 1
    border_sides = T
    border_content_tint_weight = 3
    background_content_tint_weight = 3
    background_color = #888888 0
    border_color = #1793d1 100
    background_color_hover = #888888 20
    border_color_hover = #1793d1 100
    background_color_pressed = #888888 20
    border_color_pressed = #1793d1 100

    # Background 2: Default task, Iconified task
    rounded = 9
    border_width = 1
    border_sides = TBLR
    border_content_tint_weight = 3
    background_content_tint_weight = 3
    background_color = #000000 0
    border_color = #000000 0
    background_color_hover = #888888 20
    border_color_hover = #888888 20
    background_color_pressed = #888888 20
    border_color_pressed = #888888 20

    # Background 3: Urgent task
    rounded = 9
    border_width = 1
    border_sides = T
    border_content_tint_weight = 3
    background_content_tint_weight = 3
    background_color = #888888 0
    border_color = #e64141 100
    background_color_hover = #888888 20
    border_color_hover = #e64141 100
    background_color_pressed = #888888 20
    border_color_pressed = #e64141 100

    # Background 4: Inactive taskbar
    rounded = 9
    border_width = 1
    border_sides = LR
    border_content_tint_weight = 3
    background_content_tint_weight = 3
    background_color = #212121 90
    border_color = #000000 0
    background_color_hover = #888888 20
    border_color_hover = #000000 0
    background_color_pressed = #888888 20
    border_color_pressed = #000000 0

    # Background 5: Active taskbar, Battery, Button, Launcher icon, Systray
    rounded = 9
    border_width = 1
    border_sides = LR
    border_content_tint_weight = 3
    background_content_tint_weight = 3
    background_color = #121212 90
    border_color = #d8d8d8 0
    background_color_hover = #d8d8d8 0
    border_color_hover = #d8d8d8 0
    background_color_pressed = #d8d8d8 0
    border_color_pressed = #d8d8d8 0

    # Background 6: Clock, Launcher, Tooltip
    rounded = 9
    border_width = 1
    border_sides = TBLR
    border_content_tint_weight = 3
    background_content_tint_weight = 3
    background_color = #000000 100
    border_color = #222222 90
    background_color_hover = #2b303b 100
    border_color_hover = #222222 90
    background_color_pressed = #2b303b 100
    border_color_pressed = #222222 90

    #-------------------------------------
    # Panel
    panel_items = TSC
    panel_size = 100% 28
    panel_margin = 1 0
    panel_padding = 1 1 1
    panel_background_id = 0
    wm_menu = 1
    panel_dock = 0
    panel_pivot_struts = 0
    panel_position = top left horizontal
    panel_layer = normal
    panel_monitor = all
    panel_shrink = 0
    primary = 1
    autohide = 0
    autohide_show_timeout = 0.3
    autohide_hide_timeout = 1.4
    autohide_height = 6
    strut_policy = follow_size
    panel_window_name = tint2
    disable_transparency = 0
    mouse_effects = 1
    font_shadow = 0
    mouse_hover_icon_asb = 100 0 10
    mouse_pressed_icon_asb = 100 0 0
    # Huge hack because tint2's HiDPI is a POS, find out what DPI your monitor has, according to xrandr,
    # not as defined in your X config, then find another value you can divide it by to achieve your desired
    # scale and input it here. It's awful.
    scale_relative_to_dpi = 108
    scale_relative_to_screen_height = 0

    #-------------------------------------
    # Taskbar
    taskbar_mode = single_monitor #multi_desktop
    taskbar_hide_if_empty = 1
    taskbar_padding = 1 2 1
    taskbar_background_id = 4
    taskbar_active_background_id = 5
    taskbar_name = 1
    taskbar_hide_inactive_tasks = 0
    taskbar_hide_different_monitor = 1
    taskbar_hide_different_desktop = 0
    taskbar_always_show_all_desktop_tasks = 0
    taskbar_name_padding = 1 1
    taskbar_name_background_id = 0
    taskbar_name_active_background_id = 0
    taskbar_name_font = MesloLGS Nerd Font Mono 10
    taskbar_name_font_color = #828282 100
    taskbar_name_active_font_color = #a0a0bd 100
    taskbar_distribute_size = 0
    taskbar_sort_order = title
    task_align = left

    #-------------------------------------
    # Task
    task_text = 0
    task_icon = 1
    task_centered = 1
    urgent_nb_of_blink = 20
    task_maximum_size = 30 30
    task_padding = 6 1 4
    task_font = MesloLGS Nerd Font Mono 10
    task_tooltip = 1
    task_thumbnail = 0
    task_thumbnail_size = 210
    task_font_color = #828282 60
    task_active_font_color = #828282 100
    task_urgent_font_color = #ffffff 100
    task_iconified_font_color = #d8d8d8 60
    task_active_icon_asb = 100 0 0
    task_urgent_icon_asb = 100 0 0
    task_iconified_icon_asb = 80 0 0
    task_background_id = 2
    task_active_background_id = 1
    task_urgent_background_id = 3
    task_iconified_background_id = 2
    mouse_left = toggle_iconify
    mouse_middle = close
    mouse_right = none
    mouse_scroll_up = toggle
    mouse_scroll_down = iconify

    #-------------------------------------
    # System tray (notification area)
    systray_padding = 1 1 1
    systray_background_id = 5
    systray_sort = right2left
    systray_icon_size = 0
    systray_icon_asb = 100 0 0
    systray_monitor = 2
    systray_name_filter =
    #-------------------------------------
    # Launcher
    launcher_padding = 1 0 1
    launcher_background_id = 6
    launcher_icon_background_id = 5
    launcher_icon_size = 0
    launcher_icon_asb = 100 0 0
    launcher_icon_theme = Numix-Circle
    launcher_icon_theme_override = 0
    startup_notifications = 1
    launcher_tooltip = 1
    launcher_item_app = /usr/share/applications/exo-terminal-emulator.desktop
    launcher_item_app = /usr/share/applications/exo-file-manager.desktop
    launcher_item_app = /usr/share/applications/firefox.desktop
    launcher_item_app = /usr/share/applications/geany.desktop
    launcher_item_app = /usr/share/applications/org.manjaro.pamac.manager.desktop
    launcher_item_app = /usr/share/applications/org.qbittorrent.qBittorrent.desktop
    launcher_item_app = /usr/share/applications/thunderbird.desktop

    #-------------------------------------
    # Clock
    time1_format = %a %b %d %H:%M
    time2_format =
    time1_font = MesloLGS Nerd Font Mono 10
    time1_timezone = America/Toronto
    time2_timezone =
    time2_font = sans 0
    clock_font_color = #ffffff 100
    clock_padding = 10 0
    clock_background_id = 6
    clock_tooltip =
    clock_tooltip_timezone =
    clock_lclick_command = gsimplecal
    clock_rclick_command = gsimplecal
    clock_mclick_command =
    clock_uwheel_command =
    clock_dwheel_command =

    #-------------------------------------
    # Battery
    battery_tooltip = 1
    battery_low_status = 20
    battery_low_cmd = notify-send "Battery Low"
    battery_full_cmd =
    bat1_font = MesloLGS Nerd Font Mono 10
    bat2_font = sans 0
    battery_font_color = #b5b5b5 100
    bat1_format =
    bat2_format =
    battery_padding = 6 1
    battery_background_id = 5
    battery_hide = 101
    battery_lclick_command = xfce4-power-manager-settings
    battery_rclick_command = xfce4-power-manager-settings
    battery_mclick_command =
    battery_uwheel_command =
    battery_dwheel_command =
    ac_connected_cmd =
    ac_disconnected_cmd =

    #-------------------------------------
    # Separator 1
    separator = new
    separator_background_id = 0
    separator_color = #240c0c 85
    separator_style = line
    separator_size = 4
    separator_padding = 2 0

    #-------------------------------------
    # Button 1
    # button = new
    # button_icon = ~/Hämtningar/AL.png
    # button_text =
    # button_lclick_command = jgmenu_run >/dev/null 2>&1 &
    # button_rclick_command = exo-open ~/.config/jgmenu/jgmenurc
    # button_mclick_command =
    # button_uwheel_command =
    # button_dwheel_command =
    # button_font_color = #000000 100
    # button_padding = 8 1
    # button_background_id = 5
    # button_centered = 1
    # button_max_icon_size = 26

    #-------------------------------------
    # Tooltip
    tooltip_show_timeout = 0
    tooltip_hide_timeout = 0
    tooltip_padding = 10 1
    tooltip_background_id = 6
    tooltip_font_color = #d8d8d8 100
    tooltip_font = MesloLGS Nerd Font Mono 10
    '';

  xdg.configFile."rofi/flat-orange.rasi".text = ''
    /**
    * ROFI Color theme
    * User: mbfraga
    * Copyright: Martin B. Fraga
    */

    /* rofi 1.7.0 fix */
    element-text, element-icon {
      background-color: inherit;
      text-color:       inherit;
    }

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
    font = "MesloLGS Nerd Font Mono 10";
    theme = "${config.xdg.configHome}/rofi/flat-orange.rasi";
    # colors = {
    #   window = {
    #     background = originalConfig.my.theme.color1;
    #     border = originalConfig.my.theme.color1;
    #     separator = originalConfig.my.theme.color0;
    #   };
    #   rows = {
    #     normal = {
    #       background = originalConfig.my.theme.color1;
    #       foreground = originalConfig.my.theme.color5;
    #       backgroundAlt = originalConfig.my.theme.color1;
    #       highlight = {
    #         background = originalConfig.my.theme.color1;
    #         foreground = originalConfig.my.theme.color7;
    #       };
    #     };
    #     active = {
    #       background = originalConfig.my.theme.color1;
    #       foreground = originalConfig.my.theme.colorD;
    #       backgroundAlt = originalConfig.my.theme.color1;
    #       highlight = {
    #         background = originalConfig.my.theme.color1;
    #         foreground = originalConfig.my.theme.colorD;
    #       };
    #     };
    #     urgent = {
    #       background = originalConfig.my.theme.color1;
    #       foreground = originalConfig.my.theme.color8;
    #       backgroundAlt = originalConfig.my.theme.color1;
    #       highlight = {
    #         background = originalConfig.my.theme.color1;
    #         foreground = originalConfig.my.theme.color8;
    #       };
    #     };
    #   };
    # };
    extraConfig = {
      dpi = 0;
    };
  };

  services.picom = {
    backend = originalConfig.my.picomBackend;
  };

  xsession.windowManager.i3 = rec {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      bars = [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = config.fonts;
          trayOutput = originalConfig.my.trayOutput;
          position = "top";
          colors = {
            background = originalConfig.my.theme.color1;
            statusline = originalConfig.my.theme.color1;
            separator = "#515151";
            focusedWorkspace = {
              border = originalConfig.my.theme.colorD;
              background = originalConfig.my.theme.colorD;
              text = originalConfig.my.theme.color0;
            };
            activeWorkspace = {
              border = "#333333";
              background = "#333333";
              text = originalConfig.my.theme.colorF;
            };
            inactiveWorkspace = {
              border = originalConfig.my.theme.color1;
              background = originalConfig.my.theme.color1;
              text = "#999999";
            };
            urgentWorkspace = {
              border = originalConfig.my.theme.color8;
              background = originalConfig.my.theme.color8;
              text = originalConfig.my.theme.colorF;
            };
          };
        }
      ];
      colors = {
        focused = {
          border = originalConfig.my.theme.colorD;
          childBorder = originalConfig.my.theme.colorD;
          background = originalConfig.my.theme.colorD;
          text = originalConfig.my.theme.color0;
          indicator = originalConfig.my.theme.color1;
        };
        focusedInactive = {
          border = originalConfig.my.theme.color2;
          childBorder = originalConfig.my.theme.color2;
          background = originalConfig.my.theme.color2;
          text = originalConfig.my.theme.color3;
          indicator = "#292d2e";
        };
        unfocused = {
          border = originalConfig.my.theme.color1;
          childBorder = originalConfig.my.theme.color1;
          background = originalConfig.my.theme.color1;
          text = "#999999";
          indicator = "#292d2e";
        };
        urgent= {
          border = "#2f343a";
          childBorder = "#2f343a";
          background = originalConfig.my.theme.color8;
          text = originalConfig.my.theme.colorF;
          indicator = originalConfig.my.theme.color8;
        };
      };
      fonts = {
        names = [ "Noto Sans" ];
        style = "Regular";
        size = 10.0;
      };
      workspaceAutoBackAndForth = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      startup = [
        { command = "pkill picom; ${pkgs.picom}/bin/picom --backend ${originalConfig.my.picomBackend} ${lib.optionals (originalConfig.my.picomBackend == "xrender") "--xrender-sync-fence"} ${if originalConfig.my.vsync then "--vsync" else "--no-vsync"}"; notification = false; }
        { command = "pkill xsecurelock; ${pkgs.xss-lock}/bin/xss-lock ${pkgs.coreutils}/bin/env XSECURELOCK_PASSWORD_PROMPT=time_hex XSECURELOCK_NO_COMPOSITE=1 XSECURELOCK_BLANK_DPMS_STATE=off XSECURELOCK_BLANK_TIMEOUT=30 ${pkgs.xsecurelock}/bin/xsecurelock"; notification = false; }
        { command = "pkill flameshot; ${pkgs.flameshot}/bin/flameshot"; notification = false; }
        # { command = "pkill dunst; ${pkgs.dunst}/bin/dunst"; notification = false; }
      ] ++ lib.optional (originalConfig.my.ckb)
        { command = "pkill ckb-next; ${pkgs.ckb-next}/bin/ckb-next --background"; notification = false; };
      keybindings = let mod = config.modifier; in {
        "${mod}+a" = "exec ${config.menu}";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
        "Mod1+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${mod}+Return" = "exec ${config.terminal}";
        "Control+Mod1+l" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
        "${mod}+Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
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
        "${mod}+Mod1+h" = "move workspace to output left";
        "${mod}+Mod1+j" = "move workspace to output down";
        "${mod}+Mod1+k" = "move workspace to output up";
        "${mod}+Mod1+l" = "move workspace to output right";
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
        "${mod}+g" = "gaps inner all set 10";
        "${mod}+Shift+g" = "gaps inner all set 0";

        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";

        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";

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
    extraConfig = ''
      for_window [class="^.*"] border pixel 1
      new_window 1pixel
    '';
  };

  xresources.properties = {
    "Xft.dpi" = originalConfig.my.dpi;
  };
})

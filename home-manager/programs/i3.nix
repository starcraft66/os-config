{ config, lib, pkgs, ... }:

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
          format = "<span background='#fec7cd'>  %free Free </span>";
        };
      };
      "ethernet Home@enp3s0" = {
        position = 3;
        settings = {
          format_up = "<span background='#88c0d0'>  %ip </span>";
          format_down = "<span background='#88c0d0'>  Disconnected </span>";
        };
      };
      "volume master" = {
        position = 4;
        settings = {
          format = "<span background='#ebcb8b'>  %volume </span>";
          format_muted = "<span background='#ebcb8b'>  Muted </span>";
          device = "default";
          mixer = "Master";
          mixer_idx = 0;
        };
      };
      "tztime local" = {
        position = 5;
        settings = {
          format = "<span background='#81a1c1'> %time </span>";
          format_time = " %a %-d %b %H:%M";
        };
      };
    };
  };

  services.picom = {
    backend = "xrender";
  };

  xsession.windowManager.i3 = rec {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      bars = [
        {
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = config.fonts;
          trayOutput = "DP-4";
          colors = {
            background = "#282a2e";
            statusline = "#282a2e";
            separator = "#515151";
            focusedWorkspace = {
              border = "#81a2be";
              background = "#81a2be";
              text = "#1d1f21";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#333333";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#282a2e";
              background = "#282a2e";
              text = "#999999";
            };
            urgentWorkspace = {
              border = "#f2777a";
              background = "#f2777a";
              text = "#ffffff";
            };
          };
        }
      ];
      colors = {
        focused = {
          border = "#81a2be";
          childBorder = "#81a2be";
          background = "#81a2be";
          text = "#1d1f21";
          indicator = "#282a2e";
        };
        focusedInactive = {
          border = "#373b41";
          childBorder = "#373b41";
          background = "#373b41";
          text = "#969896";
          indicator = "#292d2e";
        };
        unfocused = {
          border = "#282a2e";
          childBorder = "#282a2e";
          background = "#282a2e";
          text = "#999999";
          indicator = "#292d2e";
        };
        urgent= {
          border = "#2f343a";
          childBorder = "#2f343a";
          background = "#cc6666";
          text = "#ffffff";
          indicator = "#cc6666";
        };
      };
      fonts = [
        "pango:MesloLGS Nerd Font Mono 10"
      ];
      workspaceAutoBackAndForth = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      startup = [
        { command = "pkill picom; ${pkgs.picom}/bin/picom --backend xrender"; notification = false; }
        { command = "pkill dunst; ${pkgs.dunst}/bin/dunst"; notification = false; }
      ];
      keybindings = let mod = config.modifier; in {
        "${mod}+d" = "exec ${config.menu}";
        "${mod}+Return" = "exec ${config.terminal}";
        "${mod}+w" = "exec chromium";
        "${mod}+e" = "exec thunar";
        "${mod}+q" = "exec dmenu_run";
        "${mod}+Print" = "exec flameshot gui";
        "${mod}+Shift+q" = "kill";

        "${mod}+Shift+grave" = "move scratchpad";
        "${mod}+grave" = "scratchpad show";
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+h" = "split h";
        "${mod}+v" = "split v";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+s" = "layout stacking";
        "${mod}+Shift+t" = "layout tabbed";
        "${mod}+Shift+f" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
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
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";
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
    "Xft.dpi" = 144;
  };
}

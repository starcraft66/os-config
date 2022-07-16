{ config, osConfig, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  originalConfig = config;
  workspaces = {
    messenger = "1:";
    signal = "2:";
    spotify = "3:";
    minecraft = "6:";
    emardes = "9:";
    browser = "10:";
  };
in
(lib.mkIf isLinux {
  home.file.".background-image".source = ../../wallpapers/wallpaper_20211110.jpg;

  home.packages = with pkgs; [
    xss-lock
    xsecurelock
  ];

  services.picom = {
    enable = true;
    shadow = true;
    experimentalBackends = true;
    fade = true;
    fadeDelta = 3;
    backend = config.my.picomBackend;
    vSync = config.my.vsync;
    settings = lib.mkIf (builtins.elem "nvidia" osConfig.services.xserver.videoDrivers) {
      xrender-sync-fence = true;
    };
  };

  systemd.user.services.polkit-agent-gnome = {
    Unit = {
      Description = "Polkit GNOME agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
      # ConditionEnvironment = [ "XDG_CURRENT_DESKTOP=none+i3" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-abort";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xsession.windowManager.i3 = rec {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      bars = [
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
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      startup = [
        { command = "pkill xsecurelock; ${pkgs.xss-lock}/bin/xss-lock ${pkgs.coreutils}/bin/env XSECURELOCK_PASSWORD_PROMPT=time_hex XSECURELOCK_NO_COMPOSITE=1 XSECURELOCK_BLANK_DPMS_STATE=off XSECURELOCK_BLANK_TIMEOUT=30 ${pkgs.xsecurelock}/bin/xsecurelock"; notification = false; }
        { command = "pkill discord; ${pkgs.discord}/bin/discord"; notification = false; }
        { command = "pkill element-desktop; ${pkgs.element-desktop}/bin/element-desktop"; notification = false; }
        { command = "pkill signal-desktop; ${pkgs.signal-desktop}/bin/signal-desktop"; notification = false; }
        { command = "pkill spotify; ${pkgs.spotify}/bin/spotify"; notification = false; }
        # Not doom-emacs but it will connect to the doom server so it should be fine
        { command = "pkill emacsclient; sleep 5; ${pkgs.emacs}/bin/emacsclient -c"; notification = false; }
        { command = "pkill firefox; sleep 10; ${pkgs.firefox}/bin/firefox"; notification = false; }
      ] ++ lib.optional (originalConfig.my.ckb)
        { command = "pkill ckb-next; ${pkgs.ckb-next}/bin/ckb-next --background"; notification = false; };
      keybindings = let mod = config.modifier; in {
        "${mod}+a" = "exec ${config.menu}";
        "${mod}+e" = "exec ${(pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; })}/bin/rofi -show emoji -modi emoji";
        "${mod}+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
        "Mod1+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${mod}+Return" = "exec ${config.terminal}";
        "Control+Mod1+l" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
        "${mod}+Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
        "${mod}+Shift+q" = "kill";

        "${mod}+r" = "mode resize";
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
        "${mod}+Mod1+h" = "move workspace to output left";
        "${mod}+Mod1+j" = "move workspace to output down";
        "${mod}+Mod1+k" = "move workspace to output up";
        "${mod}+Mod1+l" = "move workspace to output right";
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
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
        "${mod}+1" = "workspace ${workspaces.messenger}";
        "${mod}+2" = "workspace ${workspaces.signal}";
        "${mod}+3" = "workspace ${workspaces.spotify}";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace ${workspaces.minecraft}";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace ${workspaces.emardes}";
        "${mod}+0" = "workspace ${workspaces.browser}";
        "${mod}+Shift+1" = "move container to workspace ${workspaces.messenger}";
        "${mod}+Shift+2" = "move container to workspace ${workspaces.signal}";
        "${mod}+Shift+3" = "move container to workspace ${workspaces.spotify}";
        "${mod}+Shift+4" = "move container to workspace 4";
        "${mod}+Shift+5" = "move container to workspace 5";
        "${mod}+Shift+6" = "move container to workspace ${workspaces.minecraft}";
        "${mod}+Shift+7" = "move container to workspace 7";
        "${mod}+Shift+8" = "move container to workspace 8";
        "${mod}+Shift+9" = "move container to workspace ${workspaces.emardes}";
        "${mod}+Shift+0" = "move container to workspace ${workspaces.browser}";
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
      gaps = {
        top = 28;
        inner = 10;
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
      workspaceOutputAssign = [
        { workspace = "${workspaces.messenger}";
          output = originalConfig.my.leftMonitor;
        }
        { workspace = "${workspaces.signal}";
          output = originalConfig.my.leftMonitor;
        }
        { workspace = "${workspaces.spotify}";
          output = originalConfig.my.leftMonitor;
        }
        { workspace = "${workspaces.minecraft}";
          output = originalConfig.my.rightMonitor;
        }
        { workspace = "${workspaces.emardes}";
          output = originalConfig.my.rightMonitor;
        }
        { workspace = "${workspaces.browser}";
          output = originalConfig.my.rightMonitor;
        }
      ];
      window.commands = [
        { command = "move container to workspace ${workspaces.spotify}"; criteria = { class = "Spotify"; }; }
        { command = "layout tabbed"; criteria = { class = "PolyMC"; }; }
      ];
      assigns = {
        "${workspaces.messenger}" = [
          { class = "discord"; }
          { class = "Element"; }
        ];
        "${workspaces.signal}" = [
          { class = "Signal"; }
        ];
        "${workspaces.minecraft}" = [
          { class = "PolyMC"; }
        ];
        "${workspaces.emardes}" = [
          { class = "Emacs"; }
        ];
        "${workspaces.browser}" = [
          { class = "firefox"; }
        ];
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

  # https://github.com/nix-community/home-manager/issues/2064#issuecomment-887300055
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
})

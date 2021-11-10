{ config, osConfig, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
(lib.mkIf isLinux {
  services.polybar = {
    enable = true;
    package = ((pkgs.polybar.overrideAttrs (old: {
      version = "unstable-2021-10-24";
      buildInputs = old.buildInputs ++ (with pkgs; [ libuv ]);
      src = pkgs.fetchFromGitHub {
        owner = "polybar";
        repo = "polybar";
        rev = "9e3b5378173de8beff437fa41d997678b604d6f3";
        sha256 = "sha256-yWSHXVOofMtBPyUAqo9TV6B//vq6x3A4XkgZ9UKw9gg=";
        fetchSubmodules = true;
      };
      cmakeFlags = [ "-DBUILD_CONFIG=no" ];
    })).override { i3GapsSupport = true; });
    config = {
      "settings" = {
        # throttle-ms = 50;
        # throttle-limit = 5;
        screenchange-reload = true;
      };

      "global/wm" = {
        margin-top = 0;
        margin-bottom = 0;
      };

      "bar/spacer" = {
        height = 42;

        # Set the width to 100% of screen
        width = "100%";

        # Fully transparent
        background = "#00000000";
        foreground = "#00000000";

        modules-center = "time";

        # HiDPI
        dpi = config.my.dpi;
      };
      "bar/main" = {
        enable-ipc = "true";
        height = 42;

        # Set the width to 100% of screen - 40 pixels
        width = "100%:-28";
        # Set an x offset of 40/2 = 20 pixels to center the bar
        offset-x = 14;
        # Set a y offset of 20 to make the bar have a fake gap at the top
        offset-y = 5;

        # Set a border
        border-size = 2;
        border-color = config.my.theme.color2;

        # Completely disable underlines
        line-size = 0;

        # Radius disabled because the systray ignores it and it looks bad
        # radius = 16;

        tray-position = "right";
        tray-detached = false;
        tray-maxsize = 24;

        background = config.my.theme.color0;
        foreground = config.my.theme.colorE;

        padding = 3;

        # font-N = <fontconfig pattern>;<vertical offset>
        # The vertical offset is very important because polybar
        # renders the font too high which makes it look like there
        # is padding/margin at the bottom of the bar. We need a y
        # offset to make the text render lower, a.k.a. "centered"
        font-0 = "Noto Sans:size=10;3";
        font-1 = "Noto Sans:size=10:style=Bold;3";
        font-2 = "Font Awesome 5 Free Regular:pixelsize=10;3";
        font-3 = "Font Awesome 5 Free Solid:pixelsize=10;3";
        font-4 = "Font Awesome 5 Brands:pixelsize=10;3";

        # Read the MONITOR env variable set by the start script
        # to start the same bar on different monitors.
        monitor = "\${env:MONITOR}";

        modules-left = "i3";
        modules-center = "time";
        modules-right = "cpu memory pulseaudio wlan eth battery";

        # Don't make i3 aware of the bar (requires fake transparent spacer bar)
        # This is required or else the x offset is ignored and the left side of the
        # bar is stuck to the side of the monitor, ruining the floating effect
        override-redirect = "true";

        # Put polybar at the bottom of the stack (behind other windows)
        # This is needed so that things like full screen apps, floating apps
        # or i3-nagbar get rendered on top of polybar
        wm-restack = "i3";

        # Switch i3 workspaces by scrolling on the entire bar
        scroll-up = "#i3.prev";
        scroll-down = "#i3.next";

        # HiDPI
        dpi = config.my.dpi;
      };

      "module/i3" = {
        type = "internal/i3";
        strip-wsnumbers = "true";
        enable-click = "true";
        reverse-scroll = "false";

        label-focused-padding = 2;
        label-visible-padding = 2;
        label-unfocused-padding = 2;
        label-urgent-padding = 2;

        label-focused-background = config.my.theme.color2;
        label-visible-background = config.my.theme.color2;
        label-unfocused-background = config.my.theme.color0;
        label-urgent-background = config.my.theme.colorA;
        # label-empty-padding = 1;
        # label-active-padding = 1;
        # label-occupied-padding = 1;

        # only show workspaces on the current monitor
        pin-workspaces = "true";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = " ";
        format-padding = 2;
        format-foreground = config.my.theme.color3;
        label = "%percentage%%";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-padding = 2;
        format-prefix = " ";
        format-foreground = config.my.theme.color3;
        label = "%percentage_used%%";
      };

      "module/wlan" = {
        type = "internal/network";
        interface = config.my.wirelessInterface;
        interval = 3;
        format-connected-margin = 2;
        format-connected-foreground = config.my.theme.color4;

        format-connected = " <label-connected>";
        label-connected = "%essid%";

        format-disconnected = "<label-disconnected>";
        format-disconnected-margin = "2";
        format-disconnected-foreground = config.my.theme.color5;
        label-disconnected = "%ifname% disconnected";
      };

      "module/eth" = {
        type = "internal/network";
        interface = config.my.wiredInterface;
        interval = 3;

        format-connected-prefix = " ";
        format-connected-prefix-color1 = config.my.theme.color1;
        label-connected = "%local_ip%";

        format-disconnected = "";
        # ;format-disconnected = <label-disconnected>
        # ;label-disconnected = %ifname% disconnected
        # ;label-disconnected-color1 = ${colors.color1-alt}
      };

      "module/time" = {
        type = "internal/date";
        interval = 10;
        format-padding = 3;

        time = "%H:%M";
        date = "%A %d %b";

        label = "%date%, %time%";
        label-padding = 2;

        # Bold font for date
        #
        # From: https://gitlab.com/polybar/polybar/-/wikis/Fonts#fonts
        # >NOTE: The -font property is a 1-based index of available fonts (which means that 1 is the first font).
        # Quite possibly the stupidest shit I've ever read in this project's docs
        # who in their right mind thought this wouldn't cause a headache?
        # This font is defined as font-1 but we actually need to say font = 2 here
        label-font = 2;
      };

      "module/pulseaudio" = {
        type = "internal/alsa";
        master-mixer = "Master";
        headphone-id = 9;
        format-volume-padding = 2;
        format-muted-padding = 2;
        label-muted = " Mute";
        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";

        format-volume-margin = 2;
        format-volume-foreground = config.my.theme.color3;
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%%";
        use-ui-max = "false";
        interval = 5;

        label-muted-background = config.my.theme.color0;
        label-muted-foreground = config.my.theme.color3;
      };

      "module/powermenu" = {
        type = "custom/menu";

        expand-right = "true";

        format-spacing = 1;
        format-margin = 0;
        format-background = config.my.theme.color0;
        format-foreground = config.my.theme.colorF;
        format-padding = 2;

        label-open = "";
        label-close = "";
        label-separator = "|";

        #; reboot
        menu-0-1 = "";
        menu-0-1-exec = "menu-open-2";
        #; poweroff
        menu-0-2 = "";
        menu-0-2-exec = "menu-open-3";
        #; logout
        menu-0-0 = "";
        menu-0-0-exec = "menu-open-1";

        menu-2-0 = "";
        menu-2-0-exec = "reboot";

        menu-3-0 = "";
        menu-3-0-exec = "poweroff";

        menu-1-0 = "";
        menu-1-0-exec = "";

      };

      "module/battery" = {
        type = "internal/battery";
        format-charging-margin = 2;
        format-charging-foreground = config.my.theme.color3;
        format-discharging-margin = 2;
        format-discharging-foreground = config.my.theme.colorE;
        format-full-margin = 2;
        format-full-foreground = config.my.theme.color3;
        full-at = 99;
        time-format = "%H:%M";
        battery = "BAT0";
        adapter = "ADP0";
        format-charging = "<animation-charging> <label-charging>";
        label-charging = "%percentage%% (%time%)";
        format-discharging = "<ramp-capacity> <label-discharging>";
        label-discharging = "%percentage%% (%time%)";
        format-full = "<label-full>";
        format-full-prefix = " ";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";

        ramp-capacity-0-foreground = config.my.theme.color0;
        ramp-capacity-foreground = config.my.theme.colorF;
        bar-capacity-width = 10;

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";

        animation-charging-framerate = 750;

        label-font = 1;
      };
    };

    script = ''
      for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
        PATH=$PATH:${pkgs.i3-gaps}/bin MONITOR=$m polybar --reload main &
      done
    '';
  };
})

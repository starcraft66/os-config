{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  originalConfig = config;
in
(lib.mkIf isLinux {
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
        frame_color = originalConfig.my.darkTheme.color5;
        font = "Sans 10";
        corner_radius = 2;
        height = "150";
        width = "350";
        offset = "0x60";
        ellipsize = "end";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        frame_color = originalConfig.my.darkTheme.color5;
        foreground = originalConfig.my.darkTheme.color4;
        background = originalConfig.my.darkTheme.color1;
        timeout = 8;
      };
      urgency_normal = {
        frame_color = originalConfig.my.darkTheme.color5;
        foreground = originalConfig.my.darkTheme.color4;
        background = originalConfig.my.darkTheme.color1;
        timeout = 8;
      };
      urgency_critical = {
        frame_color = originalConfig.my.darkTheme.color5;
        foreground = originalConfig.my.darkTheme.color4;
        background = originalConfig.my.darkTheme.color1;
        timeout = 8;
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "128x128";
    };
  };
})

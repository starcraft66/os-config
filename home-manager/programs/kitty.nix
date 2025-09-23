{ config, lib, pkgs, ... }:

let
  launcher = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
  fontFamily = "MesloLGS Nerd Font Mono";
in
{
  programs.kitty = {
    enable = true;
    font.name = fontFamily;
    settings = {
      font_size = config.my.terminalFontSize;
      enable_audio_bell = false;
      open_url_with = launcher;
      scrollback_lines = 10000;
      cursor_shape = "block";
      cursor_blink_interval = "1.0";
      cursor_stop_blinking_after = "1.0";
      cursor_text_color = "background";
      copy_on_select = "no";
      mouse_hide_wait = "3.0";
      sync_to_monitor = "yes";
      enabled_layouts = "Vertical";
      window_padding_width = "2";
      window_padding_height = "2";
      background_opacity = "0.98";

      # https://github.com/chriskempson/base16-shell/blob/master/scripts/base16-tomorrow-night.sh
      background = if config.my.deepBlackColors then config.my.darkTheme.terminalBackgroundDeep else config.my.darkTheme.terminalBackground;
      foreground = config.my.darkTheme.terminalForeground;
      selection_background = config.my.darkTheme.terminalSelectionBackground;
      selection_foreground = config.my.darkTheme.terminalSelectionForeground;
      url_color = config.my.darkTheme.color4;
      cursor = config.my.darkTheme.terminalCursorColor;
      # active_border_color = config.my.darkTheme.color3;
      # inactive_border_color = config.my.darkTheme.color1;
      # active_tab_background = config.my.darkTheme.color0;
      # active_tab_foreground = config.my.darkTheme.color5;
      # inactive_tab_background = config.my.darkTheme.color1;
      # inactive_tab_foreground = config.my.darkTheme.color4;
      # tab_bar_background = config.my.darkTheme.color1;

      # normal
      color0 = config.my.darkTheme.color0;
      color1 = config.my.darkTheme.color1;
      color2 = config.my.darkTheme.color2;
      color3 = config.my.darkTheme.color3;
      color4 = config.my.darkTheme.color4;
      color5 = config.my.darkTheme.color5;
      color6 = config.my.darkTheme.color6;
      color7 = config.my.darkTheme.color7;

      # bright
      color8 = config.my.darkTheme.color8;
      color9 = config.my.darkTheme.color9;
      color10 = config.my.darkTheme.colorA;
      color11 = config.my.darkTheme.colorB;
      color12 = config.my.darkTheme.colorC;
      color13 = config.my.darkTheme.colorD;
      color14 = config.my.darkTheme.colorE;
      color15 = config.my.darkTheme.colorF;
    };
  };
}


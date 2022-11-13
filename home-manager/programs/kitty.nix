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
      background = config.my.theme.color0;
      foreground = config.my.theme.color5;
      selection_background = config.my.theme.color5;
      selection_foreground = config.my.theme.color0;
      url_color = config.my.theme.color4;
      cursor = config.my.theme.color5;
      active_border_color = config.my.theme.color3;
      inactive_border_color = config.my.theme.color1;
      active_tab_background = config.my.theme.color0;
      active_tab_foreground = config.my.theme.color5;
      inactive_tab_background = config.my.theme.color1;
      inactive_tab_foreground = config.my.theme.color4;
      tab_bar_background = config.my.theme.color1;

      # normal
      color0 = config.my.theme.color0;
      color1 = config.my.theme.color8;
      color2 = config.my.theme.colorB;
      color3 = config.my.theme.colorA;
      color4 = config.my.theme.colorD;
      color5 = config.my.theme.colorE;
      color6 = config.my.theme.colorC;
      color7 = config.my.theme.color5;

      # bright
      color8 = config.my.theme.color3;
      color9 = config.my.theme.color8;
      color10 = config.my.theme.colorB;
      color11 = config.my.theme.colorA;
      color12 = config.my.theme.colorD;
      color13 = config.my.theme.colorE;
      color14 = config.my.theme.colorC;
      color15 = config.my.theme.color7;
    };
    # Dummy package so that we can install Kitty with Homebrew.
    package = pkgs.runCommandLocal "" { } "mkdir $out";
  };
}


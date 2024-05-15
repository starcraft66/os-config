{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  originalConfig = config;
in
(lib.mkIf isLinux {

  programs.rofi = {
    enable = true;
    font = "MesloLGS Nerd Font Mono 10";
    # Override default pywal theme
    theme = lib.mkForce "${config.xdg.cacheHome}/wal/colors-rofi-flat.rasi";
    extraConfig = {
      dpi = 0;
    };
    plugins = with pkgs; [
      rofi-emoji
    ];
    cycle = true;
    pass.enable = true;
  };

  # rasi {} are doubled {{}} to escape them in the wal template
  xdg.configFile."wal/templates/colors-rofi-flat.rasi".text = ''
    /**
    * ROFI Color theme
    * User: mbfraga
    * Copyright: Martin B. Fraga
    */

    /* rofi 1.7.0 fix */
    element-text, element-icon {{
      background-color: inherit;
      text-color:       inherit;
    }}

    /* global settings and color variables */
    * {{
      maincolor:        {color8};
      highlight:        bold {foreground};
      urgentcolor:      {color1};

      fgwhite:          {color15};
      blackdarkest:     {color0};
      blackwidget:      {color0};
      blackentry:       {color0};
      blackselect:      {color8};
      darkgray:         {color8};
      scrollbarcolor:   {color4};
      font: "MesloLGS Nerd Font Mono 10";
      background-color: @blackdarkest;
    }}

    window {{
      background-color: @blackdarkest;
      anchor: north;
      location: north;
      y-offset: 20%;
      width: 25%;
    }}

    mainbox {{
      background-color: @blackdarkest;
      spacing:0px;
      children: [inputbar, message, mode-switcher, listview];
    }}

    message {{
      padding: 6px 10px;
      background-color:@blackwidget;
    }}

    textbox {{
      text-color:@darkgray;
      background-color:@blackwidget;
    }}

    listview {{
      fixed-height: false;
      dynamic: true;
      scrollbar: true;
      spacing: 0px;
      padding: 1px 0px 0px 0px;
      margin: 0px 0px 1px 0px;
      background: @blackdarkest;
    }}

    element {{
      padding: 2px 15px;
    }}

    element normal.normal {{
      padding: 0px 15px;
      background-color: @blackentry;
      text-color: @fgwhite;
    }}

    element normal.urgent {{
      background-color: @blackentry;
      text-color: @urgentcolor;
    }}

    element normal.active {{
      background-color: @blackentry;
      text-color: @maincolor;
    }}

    element selected.normal {{
        background-color: @blackselect;
        text-color:       @fgwhite;
    }}

    element selected.urgent {{
        background-color: @urgentcolor;
        text-color:       @blackdarkest;
    }}

    element selected.active {{
        background-color: @maincolor;
        text-color:       @blackdarkest;
    }}

    element alternate.normal {{
        background-color: @blackentry;
        text-color:       @fgwhite;
    }}

    element alternate.urgent {{
        background-color: @blackentry;
        text-color:       @urgentcolor;
    }}

    element alternate.active {{
        background-color: @blackentry;
        text-color:       @maincolor;
    }}

    scrollbar {{
      background-color: @blackwidget;
      handle-color: @darkgray;
      handle-width: 15px;
    }}

    mode-switcher {{
      background-color: @blackwidget;
    }}

    button {{
      background-color: @blackwidget;
      text-color:       @darkgray;
    }}

    button selected {{
        text-color:       @maincolor;
    }}

    inputbar {{
      background-color: @blackdarkest;
      spacing: 0px;
    }}

    prompt {{
      padding:6px 9px;
      background-color: @maincolor;
      text-color:@blackwidget;
    }}

    entry {{
      padding:6px 10px;
      background-color:@blackwidget;
      text-color:@fgwhite;
    }}

    case-indicator {{
      padding:6px 10px;
      text-color:@maincolor;
      background-color:@blackwidget;
    }}
  '';

})

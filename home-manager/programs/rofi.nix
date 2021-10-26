{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  originalConfig = config;
in
(lib.mkIf isLinux {

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

})

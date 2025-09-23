{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  fontFamily = "MesloLGS Nerd Font Mono";
in
lib.mkMerge [
  (lib.mkIf isDarwin {
    programs.ghostty.package = lib.mkForce null;
  })
  {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        font-family = fontFamily;
        font-size = config.my.terminalFontSize;
        font-style = "Regular";
        theme = "dark:nix-dark,light:nix-light";
      };
      themes = {
        nix-dark = {
          palette = [
            "0=${config.my.darkTheme.color0}"
            "1=${config.my.darkTheme.color1}"
            "2=${config.my.darkTheme.color2}"
            "3=${config.my.darkTheme.color3}"
            "4=${config.my.darkTheme.color4}"
            "5=${config.my.darkTheme.color5}"
            "6=${config.my.darkTheme.color6}"
            "7=${config.my.darkTheme.color7}"
            "8=${config.my.darkTheme.color8}"
            "9=${config.my.darkTheme.color9}"
            "10=${config.my.darkTheme.colorA}"
            "11=${config.my.darkTheme.colorB}"
            "12=${config.my.darkTheme.colorC}"
            "13=${config.my.darkTheme.colorD}"
            "14=${config.my.darkTheme.colorE}"
            "15=${config.my.darkTheme.colorF}"
          ];
          background = if config.my.deepBlackColors then config.my.darkTheme.terminalBackgroundDeep else config.my.darkTheme.terminalBackground;
          foreground = config.my.darkTheme.terminalForeground;
          cursor-color = config.my.darkTheme.terminalCursorColor;
          cursor-text = config.my.darkTheme.terminalCursorText;
          selection-background = config.my.darkTheme.terminalSelectionBackground;
          selection-foreground = config.my.darkTheme.terminalSelectionForeground;
        };
        nix-light = {
          palette = [
            "0=${config.my.lightTheme.color0}"
            "1=${config.my.lightTheme.color1}"
            "2=${config.my.lightTheme.color2}"
            "3=${config.my.lightTheme.color3}"
            "4=${config.my.lightTheme.color4}"
            "5=${config.my.lightTheme.color5}"
            "6=${config.my.lightTheme.color6}"
            "7=${config.my.lightTheme.color7}"
            "8=${config.my.lightTheme.color8}"
            "9=${config.my.lightTheme.color9}"
            "10=${config.my.lightTheme.colorA}"
            "11=${config.my.lightTheme.colorB}"
            "12=${config.my.lightTheme.colorC}"
            "13=${config.my.lightTheme.colorD}"
            "14=${config.my.lightTheme.colorE}"
            "15=${config.my.lightTheme.colorF}"
          ];
          background = config.my.lightTheme.terminalBackground;
          foreground = config.my.lightTheme.terminalForeground;
          cursor-color = config.my.lightTheme.terminalCursorColor;
          cursor-text = config.my.lightTheme.terminalCursorText;
          selection-background = config.my.lightTheme.terminalSelectionBackground;
          selection-foreground = config.my.lightTheme.terminalSelectionForeground;
        };
      };
    };
  }
]

{ config, lib, pkgs, ... }:

let
  fontFamily = "MesloLGS Nerd Font Mono";
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      font-family = fontFamily;
      font-size = config.my.terminalFontSize;
      font-style = "Regular"; 
    };
  };
}


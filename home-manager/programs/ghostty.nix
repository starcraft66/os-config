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
      };
    };
  }
]

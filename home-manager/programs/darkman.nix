{ config, osConfig, lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  (lib.mkIf isLinux {
    services.darkman = {
      enable = true;
      settings = {
        lat = osConfig.location.latitude;
        lng = osConfig.location.longitude;
        usegeoclue = true;
      };
      lightModeScripts = {
        wal = ''
          ${pkgs.pywal}/bin/wal -s -l --theme base16-classic
        '';
      };
      darkModeScripts = {
        wal = ''
          ${pkgs.pywal}/bin/wal -s --theme base16-materia
        '';
      };
    };
  })
]

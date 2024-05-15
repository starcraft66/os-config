{ config, lib, pkgs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in (lib.mkIf isLinux {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
})

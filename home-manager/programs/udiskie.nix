{ config, lib, pkgs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in (lib.mkIf isLinux {
  services.udiskie = {
    enable = true;
    automount = false;
    tray = "auto";
  };
})

{ config, osConfig, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
(lib.mkIf (isLinux && config.my.wayland) {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
})

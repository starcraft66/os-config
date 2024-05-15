{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
(lib.mkIf isLinux {
  programs.pywal.enable = true;
  # home.packages = [ pkgs.pywal ];
})

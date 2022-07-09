{ config, lib, pkgs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in (lib.mkIf isLinux {
  home.packages = with pkgs; [ _1password (_1password-gui.override { polkitPolicyOwners = [ "tristan" ]; }) ];
})

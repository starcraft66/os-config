{ config, osConfig, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
(lib.mkIf isDarwin {
  # Symlink Home Manager apps to ~/Applications/Home\ Manager\ Apps
  # for Raycast (spotlight alternative)
  home.file."Applications/Home Manager Apps".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
})

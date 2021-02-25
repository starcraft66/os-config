{ pkgs, config, lib, ... }:

with lib;

{
  programs.obs-studio = {
    enable = true;
    package = pkgs.unstable.obs-studio;
    plugins = with pkgs; [
      obs-v4l2sink
      obs-linuxbrowser
      unstable.obs-move-transition
    ];
  };
}

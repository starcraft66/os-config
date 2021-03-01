{ pkgs, config, lib, ... }:

with lib;

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-v4l2sink
      obs-move-transition
    ];
  };
}

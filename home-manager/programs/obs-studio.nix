{ pkgs, config, lib, ... }:

with lib;

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      unstable.obs-v4l2sink
    ];
  };
}

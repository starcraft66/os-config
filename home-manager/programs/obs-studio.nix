{ pkgs, config, lib, ... }:

with lib;

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-move-transition
    ];
  };
}

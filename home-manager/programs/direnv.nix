{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}
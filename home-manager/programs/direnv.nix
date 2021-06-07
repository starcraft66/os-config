{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}

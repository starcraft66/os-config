{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}

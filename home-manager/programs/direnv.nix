{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
    enableZshIntegration = true;
    enableNushellIntegration = false;
  };
}

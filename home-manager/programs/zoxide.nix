{ config, lib, pkgs, ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}

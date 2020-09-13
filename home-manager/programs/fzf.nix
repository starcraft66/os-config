{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = ''${pkgs.fd}/bin/fd --follow --type f --exclude="'.git'" .'';
    defaultOptions = [ "--exact" "--cycle" "--layout=reverse" ];
    enableFishIntegration = false;
  };
}
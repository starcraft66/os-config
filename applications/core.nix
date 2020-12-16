{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    pass
    tmux
    screen
    borgbackup 
    file
    binutils
    exa
    xclip
    bat
    ripgrep
    fzf
    dconf
  ];
}

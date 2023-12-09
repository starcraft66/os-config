{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    pass
    tmux
    screen
    file
    binutils
    eza
    xclip
    bat
    ripgrep
    fzf
    dconf
  ];
}

{ pkgs, ... }:

{
  imports = [
      ./programs/alacritty.nix
      ./programs/doom-emacs.nix
      ./programs/tmux.nix
      ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

}

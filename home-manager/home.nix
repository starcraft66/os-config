{ pkgs, ... }:

{
  imports = [
      ./programs/alacritty.nix
      ./programs/doom-emacs.nix
      ./programs/tmux.nix
      ./programs/fzf.nix
      ./programs/starship.nix
      ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

}

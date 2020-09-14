{ pkgs, ... }:

{
  imports = [
      ./programs/alacritty.nix
      ./programs/doom-emacs.nix
      ./programs/tmux.nix
      ./programs/fzf.nix
      ./programs/git.nix
      ./programs/kde.nix
      ./programs/neofetch.nix
      ./programs/starship.nix
      ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

}

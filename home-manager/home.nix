{ pkgs, ... }:

{
  imports = [
      ./programs/alacritty.nix
      ./programs/tmux.nix
  ];

  programs.home-manager.enable = true;

}

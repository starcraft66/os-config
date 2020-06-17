{ pkgs, ... }:

{
  imports = [
      ./programs/alacritty.nix
  ];

  programs.home-manager.enable = true;

}

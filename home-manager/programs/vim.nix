{ config, lib, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      mouse = "a";
    };
    extraConfig = ''
      set ttymouse=xterm2
      set so=10
    '';
  };
}
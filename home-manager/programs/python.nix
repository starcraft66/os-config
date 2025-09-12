{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    uv
    poetry
  ];
}

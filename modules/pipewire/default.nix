{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.pipewire;
in
{
  options.profiles.pipewire.enable = mkEnableOption "pipewire replacement of Pulseaudio";

  config = mkMerge [
    {
    }
  ];
}

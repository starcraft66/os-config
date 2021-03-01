{ config, lib, pkgs, ... }:

{
  services.udiskie = {
    enable = true;
    automount = false;
    tray = "auto";
  };
}

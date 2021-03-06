{ config, lib, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = true;
    pinentryFlavor = "qt";
  };
}

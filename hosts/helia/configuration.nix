# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "Helia"; # Define your hostname.
  networking.firewall.allowedUDPPorts = [ 69 ];

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  services.tftpd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs;
  let
    wine-staging = wineWowPackages.staging;
    firefox-customized = firefox.override { nativeMessagingHosts = [ passff-host ]; };
  in [
    firefox-customized htop bind qt5.qttools
    networkmanager element-desktop python3 pciutils
    alacritty fastfetch spotify vscode glib prismlauncher
    roboto unzip traceroute signal-desktop iperf ethtool
    ncdu kdePackages.gwenview flameshot wine-staging winetricks
    kdePackages.breeze-gtk nautilus discord
  ];

  hardware.acpilight.enable = true;

  # NetworkManager
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.xkb.options = "ctrl:swapcaps,compose:ralt";

  # Enable touchpad support.
  services.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.dpi = 120;

  home-manager = {
    users.tristan = { ... }: {
      config.my.terminalFontSize = 10;
      config.my.ckb = false;
      config.my.dpi = 120;
      config.my.cursorDpi = 30;
      config.my.vsync = true;
      config.my.picomBackend = "glx";
      config.my.trayOutput = "eDP-1";
      config.my.leftMonitor = "eDP-1";
      config.my.rightMonitor = "eDP-1";
      config.my.wiredInterface = "enp0s31f6";
      config.my.wirelessInterface = "wlp4s0";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?
}

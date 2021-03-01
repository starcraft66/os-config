# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../applications/core.nix
    ../../applications/flake.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

  networking.hostName = "Helia"; # Define your hostname.
  networking.firewall.allowedUDPPorts = [ 69 ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  services.avahi.enable = true;
  services.tftpd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    useXkbConfig = true;
  };
  i18n.defaultLocale = "en_US.UTF-8";
  #i18n.consoleKeyMap = "us";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  location = {
    latitude = 45.50884;
    longitude = -73.58781;
  };

  # for (((steam)))
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          config = config.nixpkgs.config;
        };
        master = import <nixos-master> {
          config = config.nixpkgs.config;
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs;
  let
    wine-unstable = unstable.wineWowPackages.staging;
    winetricks-unstable = unstable.winetricks.override { wine = wine-unstable; };
    firefox-customized = firefox.override { extraNativeMessagingHosts = [ passff-host ]; };
  in [
    firefox-customized htop bind qt5.qttools
    networkmanager element-desktop python3 pciutils
    alacritty steam neofetch spotify vscode glib minecraft
    roboto font-awesome unzip traceroute signal-desktop iperf ethtool
    ncdu kdeApplications.spectacle kdeApplications.gwenview
    unstable.flameshot wine-unstable winetricks-unstable
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.wireshark = { enable = true; package = pkgs.wireshark; };

  services.pcscd.enable = true;
  services.fwupd.enable = true;
  programs.light.enable = true;

  # List services that you want to enable:
  security.pam.enableSSHAgentAuth = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # NetworkManager
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:swapcaps";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.i3 = {
    enable = true;
    # package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      rofi #application launcher most people use
      i3status # gives you the default i3 status bar
      i3lock #default i3 screen locker
      i3blocks #if you are planning on using i3blocks over i3status
      picom # compositor
      dunst # notification daemon
    ];
  };

  services.xserver.dpi = 120;

  services.redshift = {
    enable = true;
    temperature.day = 6500;
    temperature.night = 3000;
  };

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    nerdfonts
    emacs-all-the-icons-fonts
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tristan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "wireshark" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiR1wVz1/m2KXNWIUy02/yftUz+P7B/ZsPQ34PoiyJ/+SFiZBOpAX5KJhdyXwDY1l631CyzYX/yI/6I78GB6qoZGjrLG6g0lk5k70VBsdN+YadaHKn4SEs7KKmf2yNPkVWnCrXnVIqZV/ixLtwzQAnIY11pr5vpwEJjydDvb1+imtT6hyTGvVR2f3ZtBl0LryAW3RisLq9G6m+dlJtLGPJcwsSzSh+dqO9DocLPHff8gEgXyP8TqDQM8iS4lkHQYNlFs6KcSHp7/JE1RShjMSoOYy2VfrpCRrzds0GYTzuirTYo5DL1s3vQuWH5gEWk1tWht8ObjYGondZ7anz4bgXQ== rsa-key-201401"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrI5nV45rGWmbU4NjYpyUKMmmPL9JQw+V1Sy+avJxYsqUQkQAd7niZoujNKP56l0Mm1SJPGMIGnyc/711dE1fz//lupNgZnjZbavR6JnklyqwKRvZZja7I8oWBS1Vo6U8ClZvl23yeVl6NZbu97POrgyZm1EljafY1xb7H0GHe55RU9W+I/Fn9hC6CO+15Erv8FwteyqWQqOT3OBqmzttS0Tv3pqucAUFhxG6kNro9N8/KBDmJzdyHMQqv/CzhP9+r+AGkBw4P7/zRhcPTKcXKCkRKWlYFmOkS7ztCY8s+leCJulT427K4riumjHEziQ6WXvZ4Nm0ZIxI2drvb/SbHJSaV5sAIp6QPGLjrRrRH5qkew+jJLIAt+MHiAXYcE5MFG/WdepP4dxcCFDPJV93RLqUDNQfsTLOThJr/8q68qwe6J3ELVMmj+Hg8kMAYSlsnk91jo/6UAO+6uWfYvspjICeFtxYvU+gZ9wXNsUL7e2jEqHC+hfBGq01UHqFPJTwjo7FC31L/EuQDvue5z+qJsuY9uGZzk1jgs/67kvGD5whiuwo6a0F4CHxiwvlJBddYpR1S02gqYv5gsDtZyeYpcnwmhR8oagrgYQ0lkjVTFKQNkrxVZHcjbsL5krLRyXZVRISOxxekLO566BIaBT6zUujBwmCJ3wtUrI9JAtqd0w== cardno:000609029473"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8wZwiCGx/LX3xJZ0Yr323Apl43SFG2ETZsCavU06WO1OnybJOrZ6KqYQiO9mmsPjjQYHJApaJPBV2xiuOynfTPrEwZyBl0WqyaicqdczxirIez+ktNM8y/CSQ6XpmhfI/+UtdtHvlikWVEKG6oSQOi+QenXmCnIjZSqMRCOj7x3DD+D7fhIN6I+Ssw6XuPdBzAvDlpJ7vDtL2We7gA2PipX1I7erGsL3CnJzk/7ui9ha7r6Fz4WWwgEMuwx+WUxUuy9kK25SMJWwtzaHbeW3CZoLO0s9Fz4w9Z71hON/j/5xh7ynulFEiuco8zfxW6ySRf1HjlzyUN9GO2OMqqiFs8UCtvLDicv8ooCX1UCUiuEr9TwvAPx2du86bXwKpd0pq0ZZD3ymPxajbPGLLT7FYgzxUXbCpY3OeyD85dJB/JZ+5sMdPyimK26w2abLC9VCOV/+BTf15VjL8qTbby+BQNW1vLPcxauhWXVfhVV8FEVri97fj7wa9z7BIBneiIxjzjkpEWRtR8NhCBczioog81EJAFafWhcLEKBwn05YpN92iLWysBBxefIiBoynkfm+1+Ztu3z351BWxFMBod9DmOE6jf2utD12lCm1KeZ+vhnSfsfsBbhJ7/XfKvZ9ZE3igWhFw3A8FzOuuExKEKQLEgn2gUUa9bfRhdCX7PTeFTw== cardno:000609769932"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqvCOuh+/tsBgxY8I9lYauzLAQgtHSSPBLgyFzM5W0jOKsf/ijNfIFbFsNHisNLJJKCM/x03uQ6o21RHxv4OlNw/0ivLES+ZEnWpLzcQ5HZwmv95LsQRSCTNJC7R60JJVdWXUHAMuCOTzt7mVICsBSLosAI+Nw0ynlUy0OMAmnbgmQHEzWQYcWXoajS06HliPq3VoQBbgcZxLSoBtK6y3imVCqkYUB+1UzghJpWN5U0GGgqau2PVLjsi7mrGMfttDbXrQ5/0ndeEQVJs/r9RpZ+C4qZtyRqCCRnjFr5dVNRb/7HIXpVd2AEN4rNMiBLXJ4iWWExk0GVq3pKp/YeJcesMrPLQn3s+xwAPJfRB49kdHafWCGMt8yhTxMTahUwsUQeX04Sa1Yk+fehHfsxvEk5mZ8viQH27pbSNGPxfvbvhXiMftai0mvtQwDYvp7xa78Ztfogea9yZk8QpQ/M/3B9HWF7bxTlR9Hx7g2hyMBngvmEzBjEgolDXuu++B3O/pOHUikdC6dteI3gdHMW9Vgs6QR94VTXVng5ioo0Ff3UlB1f7MwkBkny+AMwSTssTq/cDa53m/aekU9REZREwHla1p1lGA6vL7RQHO9p5j4bRJ3mqJbjC4H5o0O3cdUZZBkvzi/0Pwtl+NP7aa5JG3mCP3B/BCPCqq9STl7dVpqmQ== cardno:000606923500"
    ];
  };

  home-manager = {
    users.tristan = {
      imports = [ ../../home-manager/home.nix ];

      config.my.terminalFontSize = 10;
      config.my.ckb = false;
      config.my.dpi = 120;
      config.my.cursorDpi = 30;
      config.my.vsync = true;
      config.my.picomBackend = "glx";
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}

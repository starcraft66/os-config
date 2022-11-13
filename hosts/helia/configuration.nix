# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../applications/core.nix
    ../../applications/nix.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_0;

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
  programs.steam.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  # Garbage Collection
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs;
  let
    wine-staging = wineWowPackages.staging;
    firefox-customized = firefox.override { extraNativeMessagingHosts = [ passff-host ]; };
  in [
    firefox-customized htop bind qt5.qttools
    networkmanager element-desktop python3 pciutils
    alacritty neofetch spotify vscode glib minecraft
    roboto unzip traceroute signal-desktop iperf ethtool
    ncdu gwenview flameshot wine-staging winetricks
    breeze-gtk breeze-qt5 gnome.nautilus discord
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
  services.xserver.xkbOptions = "ctrl:swapcaps,compose:ralt";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
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
    noto-fonts
    emacs-all-the-icons-fonts
    font-awesome
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxFTnA13izw+opAN3UADYe7nLU8wxjAXkLHlG3mW95dY9T5Gw58nZhCEDl/8Ozl/768P8jtRqUp+Or95YPeF8Uq3zpjs6cB+0hxPiZwU5a9r7+1Bl3yZSwDr9UYkL+Bv+g7fPgyUNAzLQvvU2IpagP4LIj8V1pYJ97RdT5cJceEB3Q4CsMFks/6KW31JfIGaGjwmAgZobJ8h3vZrTg6FyXJxJm+bB3IB+HMEsdX9HS7WCD32tP/hg2ufn27MOINjepdomFWEFUwawLrqQsu7UXuLL53Lp1aD1K1VGH7KLA+pXRTkI8SsgUbrjADU0wbx5HdclTVYgZRyv5MjvXZbduFs8WdWEdDhOWi+vM+K/S9fMVrywQOHj1J6cszyjOy33KZNcuGd1b7KEPThZldbam6hnm7mHtkcuuBXrG0wUMIDCIBEuRQ7hn1QOV2cLLKMEUOEXDMWzmvY0oLGwfZSaebYOT/m8Z5rLnsOGZUXFubKB5iQ5i2wDuwrf8MSTptsvbuKOwIDU6jOe9VIz/Z0PZ561C8a73/AWpomQZ/dF7sZJks1Ecynwq62CO1edjpNoiac61MYAd7akQhuS8xQ45AAX13aczVgUR3tCLxxz3D54cSNuhZNEfQZ16tNfikum6spF3D6x3Ky+Al3RsojJOcqEx3Ega9tteNTl57G+wmw== cardno:000613146991"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDsnJANRZDcM7GyCD8OLiJiksm5U6FyK53NDKf0nYzipI3bf2ux+9D7GqUKLbg8nw2XygSd+sO7VK/ZI5gGp1hBPyVMMljYReIZ5rY4qnidQn0j66SBY7kwLOGm/5Th/9fGjPyAJzkDJyjhF2r2HPxzojgaq3BNwMvNsnE3v401pMnOXlEY1Tz7vk2GBBS4F1aELVkCZGNzA+UGqqczbCPNFvM7Si7hayMsPBn0y0THydohvJr7yMZ/nADk7ZAK7Wpy6JpzGT8uQ0LeLrPdfo7wxf7Jkqb340e7ie1MBDjm5XYumIktH2un3Okdyq3mYBkCuGQd1lVfifsOrQKBAmU+fuQZwP4NbJvEUHEwO0k94o4VK0isHOpHhY+l8BGAGc6kZW6HrnNcMpHgWyxNib/LVfbz3qgOOdxqBv4TDlzXa2AQRplLgIm/eDLktUn8QSAQJ9jr31nd1Ec1lTIGbBVIaR0ZrtZUcFzNZ3L5MqqPP2ggPQGzW25qD+kWecy7zqW29jOX6WLeQwqbzWqNaotbPswYtKaBofp7M34wVh+3GO34lwKi0KQRqiNzbfBPcVf2jy1qqI46t3Z0nUJ4XMo5f2RhV4uSMFWkt+mTlh3HiQ2JcPr+Xec/aa/q8ZcEWJfvlM05HTv/cZCgNAbvTcS2d/6TwaMw14jxtK2WMsPOiw== cardno:000613146981"
    ];
  };

  home-manager = {
    users.tristan = { config, osConfig, ...}: {
      imports = [ ../../home-manager/home.nix ];

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
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?
}

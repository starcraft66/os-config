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
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_5_10;

  networking.hostName = "luna"; # Define your hostname.

  # Garbage Collection
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    autoOptimiseStore = true;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.wireguard.enable = true;
  services.lldpd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    # consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    fontDir = {
      enable = true;
    };
    fonts = with pkgs; [
      nerdfonts
      emacs-all-the-icons-fonts
    ];
  };

  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
    overlays = [
      (self: super:
        {
          # override with newer version from nixpkgs-unstable
          # steam = super.steam.override {
          #   extraLibraries = pkgs: with config.hardware.opengl;
          #     if pkgs.hostPlatform.is64bit
          #     then [ package pkgs.vulkan-validation-layers ] ++ extraPackages
          #     else [ package32 pkgs.vulkan-validation-layers ] ++ extraPackages32;
          # };
      #     lutris = unstable.lutris;
      #     i3-gaps = unstable.i3-gaps;
      #     steam-run = unstable.steam-run;
      #     steam-run-native = unstable.steam-run-native;
      #     hugo = unstable.hugo;
      #     linuxPackages_5_10 = unstable.linuxPackages_5_10;
      #     wineWowPackages.staging = unstable.wineWowPackages.staging;
      #     winetricks = unstable.winetricks;
      #     element-desktop = unstable.element-desktop;
      #     minecraft = unstable.minecraft;
      #     multimc = unstable.multimc;
      #     zoom-us = unstable.zoom-us;
      #     jetbrains.idea-ultimate = unstable.jetbrains.idea-ultimate;
      #     jitsi-meet-electron = unstable.jitsi-meet-electron;
      #     spotify-tui = unstable.spotify-tui;
      #     flameshot = unstable.flameshot;
      #     obs-studio = unstable.obs-studio;
      #     obs-move-transition = unstable.obs-move-transition;
      #     youtube-dl = unstable.youtube-dl;
        }
      )
    ];
  };

  # (((steam))) and (((nvidia)))
  programs.steam.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;

  # Sops config
  sops.defaultSopsFile = ../../secrets/luna.yaml;

  # Backup config
  sops.secrets.borg-repo-passphrase = {};
  sops.secrets.borg-ssh-private-key = {};
  services.borgbackup.jobs.luna = {
    paths = "/";
    exclude = [
      "/dev"
      "/proc"
      "/media"
      "/sys"
      "/mnt"
      "/sys"
      "/home/*/.local/share/Steam"
      "/run"
      "/var/lib/docker"
      "/nix"
    ];
    repo = "ssh://backup@bunker.tdude.co:7331/var/backup/luna";
    encryption = {
      mode = "repokey";
      passCommand = "cat ${config.sops.secrets.borg-repo-passphrase.path}";
    };
    environment = { BORG_RSH = "ssh -i ${ config.sops.secrets.borg-ssh-private-key.path }"; };
    doInit = false;
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs;
  let
    my-python-packages = python-packages: with python-packages; [
      pip
      pipenv
      setuptools
      virtualenv
      ansible
      pwntools
      pillow
      opencv4
      numpy
      pytesseract
      requests
      pycryptodome
    ];
    python-with-my-packages = python3.withPackages my-python-packages;
    wine-staging = wineWowPackages.staging;
    winetricks-staging = winetricks.override { wine = wine-staging; };
    firefox-customized = firefox.override { extraNativeMessagingHosts = [ passff-host ]; };
  in [
    wireshark
    element-desktop
    slack
    qtpass
    pciutils
    alacritty
    neofetch
    spotify
    vscode
    minecraft
    roboto
    font-awesome
    unzip
    traceroute
    inetutils
    vulkan-tools
    signal-desktop
    iperf
    ethtool
    irssi
    qogir-theme
    libsForQt5.qtstyleplugins
    spectacle
    firefox-customized
    python-with-my-packages
    thunderbird
    speedtest-cli
    chromium
    vagrant
    unrar
    patchelf
    fuse
    zlib
    appimage-run
    net_snmp
    tcpdump
    gns3-gui
    wireguard
    dislocker
    htop
    lm_sensors
    docker-compose
    bind
    wine-staging
    winetricks-staging
    zoom-us
    jdk11
    jetbrains.idea-ultimate
    jitsi-meet-electron
    unzip
    discord
    libreoffice
    mpv
    utillinux
    usbutils
    teleconsole
    ghidra-bin
    gimp
    gwenview
    deluge
    wmctrl
    mediainfo
    pwgen
    hugo
    ark
    pipenv
    qt5.qttools
    peek
    ncdu
    gdb
    pwndbg
    rarcrack
    yubioath-desktop
    spotify-tui
    flameshot
    rofi-pass
    zip
    obs-studio
    bmon
    adoptopenjdk-hotspot-bin-8
    kdenlive
    openshot-qt
    multimc
    nmon
    youtube-dl
    python38Packages.ds4drv
    backblaze-b2
    cava
    mtr
    virt-manager
    openfortivpn
    freerdp
    mktorrent
    mediainfo
    i2c-tools
    lolcat
    packer
    p7zip
    pamixer
    pavucontrol
    rclone
    pwgen
    psmisc
    v4l-utils
    xorg.xdpyinfo
    xorg.xev
    xorg.xmodmap
    kind
    backblaze-b2
    glxinfo
    ffmpeg
    iotop
    iperf
    lsof
    nix-index
    nmap
    audacity
    cmatrix
    figlet
    smartmontools
    lutris
  ];

  # Java
  environment.etc = with pkgs; {
    "jdk8".source = adoptopenjdk-hotspot-bin-8;
  };


  # Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuRunAsRoot = false;
  virtualisation.libvirtd.onBoot = "ignore";

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions = "--bip 10.99.0.1/24";

  # nfs shared folders
  services.nfs.server.enable = true;

  # apcupsd battery shit
  services.apcupsd.enable = true;

  # onedrive syncing
  services.onedrive.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.browserpass.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; enableExtraSocket = true; };
  programs.wireshark = { enable = true; package = pkgs.wireshark; };

  # List services that you want to enable:
  location = {
    latitude = 45.50884;
    longitude = -73.58781;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.tftpd.enable = true;
  services.pcscd.enable = true;
  services.fwupd.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  security.pam.enableSSHAgentAuth = true;

  services.xserver.deviceSection = ''
    Option "UseEdidDpi" "False"
    Option "DPI" "144 x 144"
  '';

  services.xserver.screenSection = ''
    Option         "metamodes" "DP-4: nvidia-auto-select +3840+0 {ForceCompositionPipeline=On}, DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
  '';

  services.redshift = {
    enable = true;
    temperature.day = 6500;
    temperature.night = 3000;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 2049 111 6881 ];
  networking.firewall.allowedUDPPorts = [ 2049 111 ];
  networking.firewall.logRefusedConnections = true;
  networking.firewall.logRefusedUnicastsOnly = true;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # No comment...
  sops.secrets.nocom-wireguard-private-key = {};
  networking.wireguard.interfaces = {
    nocom = {
      privateKeyFile = config.sops.secrets.nocom-wireguard-private-key.path;
      ips = [
        "192.168.69.72/24"
      ];
      peers = [
        {
          allowedIPs = [
            "192.168.69.0/24"
          ];
          publicKey = "r+4gwEuOKEXMJEQvM1YX5jc5WHIpjjZGAKW8SkRVyVQ=";
          endpoint = "fiki.dev:14030";
        }
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.wallpaper.combineScreens = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tristan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "wireshark" "libvirtd" "docker" ]; # Enable ‘sudo’ for the user.
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

      config.my.terminalFontSize = 12;
      config.my.ckb = true;
      config.my.dpi = 144;
      config.my.cursorDpi = 48;
      config.my.vsync = false;
      config.my.picomBackend = "xrender";
      config.my.trayOutput = "DP-4";
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

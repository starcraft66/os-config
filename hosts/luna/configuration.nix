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
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_1;

  networking.hostName = "luna"; # Define your hostname.

  services.tor.enable = true;

  profiles.pipewire.enable = true;

  # Garbage Collection
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
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
      noto-fonts
      font-awesome
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
    repo = "ssh://backup@borgbackup.235.tdude.co/mnt/borgbackup/luna";
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

  # systemd.user.services.scream = {
  #   enable = true;
  #   description = "Scream Audio Receiver";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.scream}/bin/scream-alsa -i virbr0";
  #     Restart = "always";
  #     RestartSec = "5";
  #   };

  #   wantedBy = [ "default.target" ];
  #   requires = [ "pulseaudio.service" ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "tristan" ];
  };

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
    python-with-my-packages = python39.withPackages my-python-packages;
    wine-staging = wineWowPackages.staging;
    firefox-customized = firefox.override { extraNativeMessagingHosts = [ passff-host ]; };
  in [
    breeze-gtk
    breeze-qt5
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
    net-snmp
    tcpdump
    wireguard-tools
    dislocker
    htop
    lm_sensors
    podman-compose
    bind
    wine-staging
    winetricks
    zoom-us
    jdk11
    jetbrains.idea-ultimate
    android-studio
    # jitsi-meet-electron
    unzip
    discord
    libreoffice
    mpv
    # utillinux
    usbutils
    ghidra-bin
    gimp-with-plugins
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
    yubioath-flutter
    spotify-tui
    flameshot
    rofi-pass
    zip
    obs-studio
    bmon
    adoptopenjdk-hotspot-bin-8
    kdenlive
    openshot-qt
    prismlauncher
    nmon
    youtube-dl
    python38Packages.ds4drv
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
    looking-glass-client
    qbittorrent
    parallel
    jq
    yq
    (retroarch.override { cores = with libretro; [ bsnes-mercury ]; })
    mupen64plus
    asciinema
    gnome.nautilus
  ];

  # Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.runAsRoot = false;
  virtualisation.libvirtd.onBoot = "ignore";

  # podman
  virtualisation.podman = {
    enable = true;
    enableNvidia = true;
    dockerCompat = true;
  };

  # nfs shared folders
  services.nfs.server.enable = true;

  # apcupsd battery shit
  services.apcupsd.enable = true;

  # onedrive syncing
  services.onedrive.enable = true;

  # mullvad vpn
  services.mullvad-vpn.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.browserpass.enable = true;
  programs.wireshark = { enable = true; package = pkgs.wireshark; };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };


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
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
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
    Option         "metamodes" "DP-4: 3840x2160_144 +3840+0 {ForceCompositionPipeline=Off}, DP-0: 3840x2160_60 +0+0 {ForceCompositionPipeline=Off, AllowGSYNCCompatible=On}"
  '';

  services.redshift = {
    enable = true;
    temperature.day = 6500;
    temperature.night = 3000;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 2049 111 6881 ];
  networking.firewall.allowedUDPPorts = [ 2049 111 ];
  # For scream audio in my windows VM
  networking.firewall.interfaces.virbr0.allowedUDPPorts = [ 4010 ];
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
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "compose:ralt";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "tile";

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
    extraGroups = [ "wheel" "networkmanager" "video" "wireshark" "libvirtd" "cdrom" "dialout" ]; # Enable ‘4udo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiR1wVz1/m2KXNWIUy02/yftUz+P7B/ZsPQ34PoiyJ/+SFiZBOpAX5KJhdyXwDY1l631CyzYX/yI/6I78GB6qoZGjrLG6g0lk5k70VBsdN+YadaHKn4SEs7KKmf2yNPkVWnCrXnVIqZV/ixLtwzQAnIY11pr5vpwEJjydDvb1+imtT6hyTGvVR2f3ZtBl0LryAW3RisLq9G6m+dlJtLGPJcwsSzSh+dqO9DocLPHff8gEgXyP8TqDQM8iS4lkHQYNlFs6KcSHp7/JE1RShjMSoOYy2VfrpCRrzds0GYTzuirTYo5DL1s3vQuWH5gEWk1tWht8ObjYGondZ7anz4bgXQ== rsa-key-201401"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrI5nV45rGWmbU4NjYpyUKMmmPL9JQw+V1Sy+avJxYsqUQkQAd7niZoujNKP56l0Mm1SJPGMIGnyc/711dE1fz//lupNgZnjZbavR6JnklyqwKRvZZja7I8oWBS1Vo6U8ClZvl23yeVl6NZbu97POrgyZm1EljafY1xb7H0GHe55RU9W+I/Fn9hC6CO+15Erv8FwteyqWQqOT3OBqmzttS0Tv3pqucAUFhxG6kNro9N8/KBDmJzdyHMQqv/CzhP9+r+AGkBw4P7/zRhcPTKcXKCkRKWlYFmOkS7ztCY8s+leCJulT427K4riumjHEziQ6WXvZ4Nm0ZIxI2drvb/SbHJSaV5sAIp6QPGLjrRrRH5qkew+jJLIAt+MHiAXYcE5MFG/WdepP4dxcCFDPJV93RLqUDNQfsTLOThJr/8q68qwe6J3ELVMmj+Hg8kMAYSlsnk91jo/6UAO+6uWfYvspjICeFtxYvU+gZ9wXNsUL7e2jEqHC+hfBGq01UHqFPJTwjo7FC31L/EuQDvue5z+qJsuY9uGZzk1jgs/67kvGD5whiuwo6a0F4CHxiwvlJBddYpR1S02gqYv5gsDtZyeYpcnwmhR8oagrgYQ0lkjVTFKQNkrxVZHcjbsL5krLRyXZVRISOxxekLO566BIaBT6zUujBwmCJ3wtUrI9JAtqd0w== cardno:000609029473"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8wZwiCGx/LX3xJZ0Yr323Apl43SFG2ETZsCavU06WO1OnybJOrZ6KqYQiO9mmsPjjQYHJApaJPBV2xiuOynfTPrEwZyBl0WqyaicqdczxirIez+ktNM8y/CSQ6XpmhfI/+UtdtHvlikWVEKG6oSQOi+QenXmCnIjZSqMRCOj7x3DD+D7fhIN6I+Ssw6XuPdBzAvDlpJ7vDtL2We7gA2PipX1I7erGsL3CnJzk/7ui9ha7r6Fz4WWwgEMuwx+WUxUuy9kK25SMJWwtzaHbeW3CZoLO0s9Fz4w9Z71hON/j/5xh7ynulFEiuco8zfxW6ySRf1HjlzyUN9GO2OMqqiFs8UCtvLDicv8ooCX1UCUiuEr9TwvAPx2du86bXwKpd0pq0ZZD3ymPxajbPGLLT7FYgzxUXbCpY3OeyD85dJB/JZ+5sMdPyimK26w2abLC9VCOV/+BTf15VjL8qTbby+BQNW1vLPcxauhWXVfhVV8FEVri97fj7wa9z7BIBneiIxjzjkpEWRtR8NhCBczioog81EJAFafWhcLEKBwn05YpN92iLWysBBxefIiBoynkfm+1+Ztu3z351BWxFMBod9DmOE6jf2utD12lCm1KeZ+vhnSfsfsBbhJ7/XfKvZ9ZE3igWhFw3A8FzOuuExKEKQLEgn2gUUa9bfRhdCX7PTeFTw== cardno:000609769932"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqvCOuh+/tsBgxY8I9lYauzLAQgtHSSPBLgyFzM5W0jOKsf/ijNfIFbFsNHisNLJJKCM/x03uQ6o21RHxv4OlNw/0ivLES+ZEnWpLzcQ5HZwmv95LsQRSCTNJC7R60JJVdWXUHAMuCOTzt7mVICsBSLosAI+Nw0ynlUy0OMAmnbgmQHEzWQYcWXoajS06HliPq3VoQBbgcZxLSoBtK6y3imVCqkYUB+1UzghJpWN5U0GGgqau2PVLjsi7mrGMfttDbXrQ5/0ndeEQVJs/r9RpZ+C4qZtyRqCCRnjFr5dVNRb/7HIXpVd2AEN4rNMiBLXJ4iWWExk0GVq3pKp/YeJcesMrPLQn3s+xwAPJfRB49kdHafWCGMt8yhTxMTahUwsUQeX04Sa1Yk+fehHfsxvEk5mZ8viQH27pbSNGPxfvbvhXiMftai0mvtQwDYvp7xa78Ztfogea9yZk8QpQ/M/3B9HWF7bxTlR9Hx7g2hyMBngvmEzBjEgolDXuu++B3O/pOHUikdC6dteI3gdHMW9Vgs6QR94VTXVng5ioo0Ff3UlB1f7MwkBkny+AMwSTssTq/cDa53m/aekU9REZREwHla1p1lGA6vL7RQHO9p5j4bRJ3mqJbjC4H5o0O3cdUZZBkvzi/0Pwtl+NP7aa5JG3mCP3B/BCPCqq9STl7dVpqmQ== cardno:000606923500"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxFTnA13izw+opAN3UADYe7nLU8wxjAXkLHlG3mW95dY9T5Gw58nZhCEDl/8Ozl/768P8jtRqUp+Or95YPeF8Uq3zpjs6cB+0hxPiZwU5a9r7+1Bl3yZSwDr9UYkL+Bv+g7fPgyUNAzLQvvU2IpagP4LIj8V1pYJ97RdT5cJceEB3Q4CsMFks/6KW31JfIGaGjwmAgZobJ8h3vZrTg6FyXJxJm+bB3IB+HMEsdX9HS7WCD32tP/hg2ufn27MOINjepdomFWEFUwawLrqQsu7UXuLL53Lp1aD1K1VGH7KLA+pXRTkI8SsgUbrjADU0wbx5HdclTVYgZRyv5MjvXZbduFs8WdWEdDhOWi+vM+K/S9fMVrywQOHj1J6cszyjOy33KZNcuGd1b7KEPThZldbam6hnm7mHtkcuuBXrG0wUMIDCIBEuRQ7hn1QOV2cLLKMEUOEXDMWzmvY0oLGwfZSaebYOT/m8Z5rLnsOGZUXFubKB5iQ5i2wDuwrf8MSTptsvbuKOwIDU6jOe9VIz/Z0PZ561C8a73/AWpomQZ/dF7sZJks1Ecynwq62CO1edjpNoiac61MYAd7akQhuS8xQ45AAX13aczVgUR3tCLxxz3D54cSNuhZNEfQZ16tNfikum6spF3D6x3Ky+Al3RsojJOcqEx3Ega9tteNTl57G+wmw== cardno:000613146991"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDsnJANRZDcM7GyCD8OLiJiksm5U6FyK53NDKf0nYzipI3bf2ux+9D7GqUKLbg8nw2XygSd+sO7VK/ZI5gGp1hBPyVMMljYReIZ5rY4qnidQn0j66SBY7kwLOGm/5Th/9fGjPyAJzkDJyjhF2r2HPxzojgaq3BNwMvNsnE3v401pMnOXlEY1Tz7vk2GBBS4F1aELVkCZGNzA+UGqqczbCPNFvM7Si7hayMsPBn0y0THydohvJr7yMZ/nADk7ZAK7Wpy6JpzGT8uQ0LeLrPdfo7wxf7Jkqb340e7ie1MBDjm5XYumIktH2un3Okdyq3mYBkCuGQd1lVfifsOrQKBAmU+fuQZwP4NbJvEUHEwO0k94o4VK0isHOpHhY+l8BGAGc6kZW6HrnNcMpHgWyxNib/LVfbz3qgOOdxqBv4TDlzXa2AQRplLgIm/eDLktUn8QSAQJ9jr31nd1Ec1lTIGbBVIaR0ZrtZUcFzNZ3L5MqqPP2ggPQGzW25qD+kWecy7zqW29jOX6WLeQwqbzWqNaotbPswYtKaBofp7M34wVh+3GO34lwKi0KQRqiNzbfBPcVf2jy1qqI46t3Z0nUJ4XMo5f2RhV4uSMFWkt+mTlh3HiQ2JcPr+Xec/aa/q8ZcEWJfvlM05HTv/cZCgNAbvTcS2d/6TwaMw14jxtK2WMsPOiw== cardno:000613146981"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/J+vzZtv/1CQzmHfgLGsLWowvSJRKr23N+NnBNg1l0dT/cPFTeDtr9kggPaHkdc587kziHFcUtkbewR8r4PgH4xMn272OPwd5r+HT1fffcE1SZO05GaxMvbXwrN6duK9EihtTpp/roitiJ/SmUX5S4YW0lzULUZG6sHDtJ7P5gPACdt/eLN50qwRVxq1yrfD2JfsI9hTFwud75HjPUDtPqL7yhfnuJ1xrbtP7Fzqs70eFQCtm7VcHa5b4azUytHBeHlf3OwBVopkiV7PUzH0UKZ+FMX3T19JyVAKPRvkuL4i2foxQthD4m/Wlr4szK2Z2yzXjAthxD2rwqlY+UiRCwWTIus12fSWS4lZWdkpqhRBXCL/fovkBWg9k4jO3Gkdt+CgbA47mcyBt5wRT013n4SPdAoIDxWRwW14T3urUoBUqjMgHlRy3s2i9cyb+dYzmeu8XIJ0YqvIUmXibTST8DOFKF16I5FqzC2SkVIrqwemqpL6Hk4BltWiZuhMu9ObBqjEKLDQ/JKvbHJH+vM2kS2JXWFfD8TUpS7nen7rTVnl2nwbBl2Ca7uchqIdQ+gOF+Mox1ncfUJ6bDAQ/QEyBCxa2u346hfvZ6Pcg1Dp8muXvkD27vLN7qUdYGnOG518gSTH4dAOYe9gaKYwDWMyH1FGNrW3052pNTN4TphEQpw== cardno:16 738 578"
    ];
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0666 tristan qemu-libvirtd -"
  ];

  home-manager = {
    users.tristan = { config, osConfig, ...}: {
      imports = [ ../../home-manager/home.nix ];

      config.my.terminalFontSize = 12;
      config.my.ckb = true;
      config.my.dpi = 144;
      config.my.cursorDpi = 48;
      config.my.vsync = true;
      config.my.picomBackend = "glx";
      config.my.trayOutput = "DP-4";
      config.my.leftMonitor = "DP-0";
      config.my.rightMonitor = "DP-4";
      config.my.wiredInterface = "enp5s0";
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  systemd.packages = [
    (pkgs.runCommand "delegate.conf" {
      preferLocalBuild = true;
      allowSubstitutes = false;
    } ''
      mkdir -p $out/etc/systemd/system/user@.service.d/
      echo -e "[Service]\nDelegate=yes" > $out/etc/systemd/system/user@.service.d/delegate.conf
    '')
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?
}

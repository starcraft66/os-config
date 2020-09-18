# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  masterTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
in

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../applications/core.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "luna"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.vlans.Management = { id = 52; interface = "enp3s0"; };
  networking.vlans.Home = { id = 51; interface = "enp3s0"; };
  networking.interfaces.enp3s0.useDHCP = false;
  networking.interfaces.Home.useDHCP = true;
  networking.interfaces.Management.useDHCP = true;
  networking.defaultGateway.address = "";
  networking.defaultGateway.interface = "enp3s0.51";
  networking.defaultGateway.metric = 10;
  #networking.defaultGateway6.address = "";
  #networking.defaultGateway6.interface = "enp3s0.51";
  #networking.defaultGateway6.metric = 10;
  networking.wireguard.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    # consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      nerdfonts
      emacs-all-the-icons-fonts
    ];
  };

  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      master = import masterTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # (((steam))) and (((nvidia)))
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ libva ];

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
    ];
    python-with-my-packages = python3.withPackages my-python-packages;
    wine-unstable = unstable.wine.override { wineBuild = "wineWow"; wineRelease = "staging"; };
    winetricks-unstable = unstable.winetricks.override { wine = wine-unstable; };
    firefox-customized = firefox.override { extraNativeMessagingHosts = [ passff-host ]; };
  in [
    wireshark networkmanager unstable.element-desktop slack qtpass pciutils
    alacritty steam neofetch spotify vscode minecraft roboto font-awesome
    unzip traceroute signal-desktop iperf ethtool irssi qogir-theme libsForQt5.qtstyleplugins
    spectacle firefox-customized python-with-my-packages virtmanager-qt thunderbird speedtest-cli
    chromium vagrant unrar patchelf fuse zlib appimage-run net_snmp
    tcpdump gns3-gui minecraft wireguard dislocker obs-studio htop lm_sensors
    docker-compose bind wine-unstable winetricks-unstable unstable.zoom-us
    jdk11 unstable.jetbrains.idea-ultimate unstable.jitsi-meet-electron
    unzip master.discord libreoffice mpv utillinux usbutils teleconsole
    pulseaudio-dlna ghidra-bin gimp unstable.cryptsetup gwenview deluge
    ark pipenv qt5.qttools peek
  ];


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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; enableExtraSocket = true; };
  programs.wireshark = { enable = true; package = pkgs.wireshark; };

  # List services that you want to enable:
  location.provider = "geoclue2";

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

  services.xserver.screenSection = ''
    Option         "metamodes" "DP-4: nvidia-auto-select +3840+0 {ForceCompositionPipeline=On}, DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
  '';

  services.redshift = {
    enable = true;
    temperature.day = 6500;
    temperature.night = 3000;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 2049 111 ];
  networking.firewall.allowedUDPPorts = [ 2049 111 ];
  networking.firewall.logRefusedConnections = true;
  networking.firewall.logRefusedUnicastsOnly = true;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # u2f
  hardware.u2f.enable = true;

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
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tristan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "wireshark" "libvirtd" "docker" ]; # Enable ‘sudo’ for the user.
  };

  home-manager = {
    users.tristan = {
      imports = [ ../../home-manager/home.nix ];

      options.my.terminalFontSize = lib.mkOption {
        description = "The terminal font size";
        type = lib.types.int;
      };

      config.my.terminalFontSize = 12;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
  boot.kernelPackages = pkgs.linuxPackages_latest;

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


  # for (((steam)))
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  environment.systemPackages = with pkgs;
  let
    firefox-customized = firefox.override { extraNativeMessagingHosts = [ passff-host ]; };
  in [
    firefox-customized htop bind qt5.qttools
    networkmanager element-desktop python3
    alacritty steam neofetch spotify vscode glib minecraft
    roboto font-awesome unzip traceroute signal-desktop iperf ethtool
    ncdu kdeApplications.spectacle kdeApplications.gwenview
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.wireshark = { enable = true; package = pkgs.wireshark; };

  hardware.u2f.enable = true;
  services.pcscd.enable = true;
  services.fwupd.enable = true;
  programs.light.enable = true;

  # List services that you want to enable:

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

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    liberation_ttf
    fira-code
    fira-code-symbols
    joypixels 
    nerdfonts
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tristan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "wireshark" ]; # Enable ‘sudo’ for the user.
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


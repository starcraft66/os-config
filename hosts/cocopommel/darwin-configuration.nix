{ config, pkgs, lib, ... }:

{
  imports = [
    ../../applications/core.nix
    ../../applications/nix.nix
  ];
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      nerdfonts
      emacs-all-the-icons-fonts
    ];
  };

  programs.zsh.enable = true;

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  users = {
    users."tristan.gosselin-hane" = {
      home = "/Users/tristan.gosselin-hane";
      isHidden = false;
      shell = pkgs.zsh;
    };
    nix.configureBuildUsers = true;
  };

  home-manager = {
    users."tristan.gosselin-hane" = { config, osConfig, ... }: {
      imports = [ ../../home-manager/home.nix ];

      config.my.terminalFontSize = 18;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  services.redis = {
    enable = true;
    dataDir = "/var/db/redis";
  };

  # Homebrew integration
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    brews = [
    ];
    cleanup = "zap";
    taps = [
      "homebrew/cask"
    ];
    casks = [
      "burp-suite"
      "cyberduck"
      "db-browser-for-sqlite"
      "dosbox"
      "mixxx"
      "raycast"
      "vlc"
      "wireshark"
      "discord"
      "spotify"
      "slack"
      "insomnia"
      "kitty"
      "openmtp"
      "rectangle"
    ];
    masApps = {
    };
  };

  services.nix-daemon.enable = true;
  nix.trustedUsers = [ "tristan.gosselin-hane" "@admin" ];
  services.activate-system.enable = true;
  nix.gc.automatic = true;
  nix.maxJobs = lib.mkDefault 8;
  
  nix.useSandbox = false;
  nix.sandboxPaths = [ "/System/Library/Frameworks" "/System/Library/PrivateFrameworks" "/usr/lib" "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

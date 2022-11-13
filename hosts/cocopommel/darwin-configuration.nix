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
    fontDir = {
      enable = true;
    };
    fonts = with pkgs; [
      nerdfonts
      # emacs-all-the-icons-fonts
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
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    taps = [
      "homebrew/cask"
    ];
    casks = [
      "burp-suite"
      "cyberduck"
      "discretescroll"
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
      "lens"
      "obs"
      "prismlauncher"
      "azure-cli"
    ];
    masApps = {
    };
  };

  services.nix-daemon.enable = true;
  nix = {
    gc.automatic = true;
    configureBuildUsers = true;
    distributedBuilds = true;
    buildMachines = [
      {
        systems = [ "x86_64-linux" ];
        supportedFeatures = [ "kvm" "big-parallel" ];
        sshUser = "tristan";
        maxJobs = 24;
        hostName = "luna.local";
        sshKey = "/Users/tristan.gosselin-hane/.ssh/id_nixstore_luna";
        publicHostKey = "AAAAC3NzaC1lZDI1NTE5AAAAIBdrtUDqfsbYGx6e2K7BfRiL8WfF3tycSwFj3lVfJFyL";
      }
      # {
      #   systems = [ "x86_64-linux" ];
      #   supportedFeatures = [ "big-parallel" ];
      #   sshUser = "root";
      #   maxJobs = 8;
      #   hostName = "172.16.2.6";
      #   sshKey = "/Users/tristan.gosselin-hane/.ssh/id_nixstore_builder";
      #   publicHostKey = "H+DeIUeuXgqoDI+XcNL43mBheZGSIBRHrPz/mrIIQqw";
      # }
    ];
    settings = {
      # package = pkgs.nix;
      trusted-users = [ "tristan" "@admin" ];
      max-jobs = lib.mkDefault 8;
      sandbox = false;
      extra-sandbox-paths = [ "/private/var/db/oah" "/Library/Apple" "/System/Library/Frameworks" "/System/Library/PrivateFrameworks" "/usr/lib" "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];
    };
  };

  services.activate-system.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

{ config, pkgs, lib, inputs, ... }:

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
    packages = with pkgs; [
      nerd-fonts.meslo-lg
      # emacs-all-the-icons-fonts
    ];
  };

  programs.zsh.enable = true;

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  users = {
    users.tristan = {
      home = "/Users/tristan";
      isHidden = false;
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users.tristan = { ... }: {
      imports = [ ../../home-manager/home.nix ];

      config.my.terminalFontSize = 18;
    };
    extraSpecialArgs = { inherit inputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # Homebrew integration
  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "tristan";
  };

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
    ];
    casks = [
      "adoptopenjdk"
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
      # "openmtp"
      "rectangle"
      "lens"
      "obs"
      "prismlauncher"
      "ghidra"
      "hex-fiend"
      "stolendata-mpv"
      "yubico-authenticator"
      # "monokle"
    ];
    masApps = {
    };
  };

  # Use a custom configuration.nid location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    configureBuildUsers = true;
    gc.automatic = true;
    distributedBuilds = true;
    buildMachines = [
      {
        systems = [ "x86_64-linux" ];
        supportedFeatures = [ "kvm" "big-parallel" ];
        sshUser = "root";
        maxJobs = 32;
        hostName = "lava.tdude.co";
        sshKey = "/Users/tristan/.ssh/id_nixstore_lava";
        # publicHostKey = "AAAAC3NzaC1lZDI1NTE5AAAAIBdrtUDqfsbYGx6e2K7BfRiL8WfF3tycSwFj3lVfJFyL";
      }
#      {
#        systems = [ "x86_64-linux" ];
#        supportedFeatures = [ "kvm" "big-parallel" ];
#        sshUser = "tristan";
#        maxJobs = 24;
#        hostName = "luna.local";
#        sshKey = "/Users/tristan/.ssh/id_nixstore_luna";
#        # publicHostKey = "AAAAC3NzaC1lZDI1NTE5AAAAIBdrtUDqfsbYGx6e2K7BfRiL8WfF3tycSwFj3lVfJFyL";
#      }
#      {
#        systems = [ "x86_64-linux" ];
#        supportedFeatures = [ "big-parallel" ];
#        sshUser = "root";
#        maxJobs = 8;
#        hostName = "172.16.2.6";
#        sshKey = "/Users/tristan/.ssh/id_nixstore_builder";
#        # publicHostKey = "H+DeIUeuXgqoDI+XcNL43mBheZGSIBRHrPz/mrIIQqw";
#      }
    ];
    settings = {
      # package = pkgs.nix;
      trusted-users = [ "tristan" "@admin" ];
      max-jobs = lib.mkDefault 8;

      sandbox = false;
      extra-sandbox-paths = [ "/System/Library/Frameworks" "/System/Library/PrivateFrameworks" "/usr/lib" "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];
    };
  };

  services.activate-system.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}

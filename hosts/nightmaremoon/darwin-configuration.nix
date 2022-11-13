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
    users.tristan = {
      home = "/Users/tristan";
      isHidden = false;
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users.tristan = { config, osConfig, ...}: {
      imports = [ ../../home-manager/home.nix ];

      config.my.terminalFontSize = 18;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # Homebrew integration
  homebrew = {
    enable = true;
    brewPrefix = "/usr/local/bin";
    brews = [
    ];
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
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
      "openmtp"
      "rectangle"
      "lens"
      "obs"
      "prismlauncher"
      "ghidra"
      "hex-fiend"
      "mpv"
      "yubico-authenticator"
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
  system.stateVersion = 4;
}

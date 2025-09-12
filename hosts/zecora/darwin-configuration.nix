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

  # Using Determinate Nix
  nix.enable = false;

  determinate-nix.customSettings = {
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.primaryUser = "tristan";
}

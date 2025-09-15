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

  # Sudo touch id
  security.pam.services.sudo_local.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.meslo-lg
      # emacs-all-the-icons-fonts
    ];
  };

  programs.zsh.enable = true;

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  users = {
    users."tristan.g-hane" = {
      home = "/Users/tristan.g-hane";
      isHidden = false;
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users."tristan.g-hane" = { ... }: {
      imports = [
        ../../home-manager/home.nix
        ../../home-manager/programs/workleap.nix
      ];

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
    autoMigrate = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "tristan.g-hane";
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
      "cyberduck"
      "discretescroll"
      "raycast"
      "vlc"
      "discord"
      "spotify"
      "insomnia"
      "kitty"
      "rectangle"
      "lens"
      "jordanbaird-ice"
      "meetingbar"
      "obs"
      "orbstack"
      "prismlauncher"
      "hex-fiend"
      "stolendata-mpv"
      "visual-studio-code"
      "jetbrains-toolbox"
    ];
    masApps = {
    };
  };

  # Using Determinate Nix
  nix.enable = false;

  determinate-nix.customSettings = let
    caches = import ../../caches;
  in {
    substituters = caches.nix.settings.substituters;
    trusted-public-keys = caches.nix.settings.trusted-public-keys;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.primaryUser = "tristan.g-hane";
}

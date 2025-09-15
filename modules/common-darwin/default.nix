{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ../../applications/core.nix
    ../../applications/nix.nix
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

  home-manager = {
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
    
    user = config.system.primaryUser;
  };
  
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    casks = [
      "discretescroll"
      "raycast"
      "vlc"
      "discord"
      "spotify"
      "slack"
      "insomnia"
      "kitty"
      "ghostty"
      "rectangle"
      "jordanbaird-ice"
      "obs"
      "imhex"
      "visual-studio-code"
    ];
  };

  # Using Determinate Nix
  nix.enable = false;

  determinate-nix.customSettings = let
    caches = import ../../caches;
  in {
    substituters = caches.nix.settings.substituters;
    trusted-public-keys = caches.nix.settings.trusted-public-keys;
  };

}
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../applications/core.nix
    ../../applications/flake.nix
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
    users.tristan = {
      home = "/Users/tristan";
      isHidden = false;
      shell = pkgs.zsh;
    };
    nix.configureBuildUsers = true;
  };

  home-manager = {
    users.tristan = {
      imports = [ ../../home-manager/home.nix ];

      config.my.terminalFontSize = 18;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # Use a custom configuration.nid location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix.trustedUsers = [ "tristan" "@admin" ];
  services.activate-system.enable = true;
  nix.gc.automatic = true;
  
  nix.useSandbox = false;
  nix.sandboxPaths = [ "/System/Library/Frameworks" "/System/Library/PrivateFrameworks" "/usr/lib" "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

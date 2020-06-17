{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.nerdfonts ];
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
  
  nix.useSandbox = true;
  nix.sandboxPaths = [ "/System/Library/Frameworks" "/System/Library/PrivateFrameworks" "/usr/lib" "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

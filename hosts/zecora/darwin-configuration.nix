{ config, pkgs, lib, inputs, ... }:

{
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
      config.my.deepBlackColors = true;
    };
  };

  homebrew = {
    brews = [
    ];
    taps = [
    ];
    casks = [
      "adoptopenjdk"
      "burp-suite"
      "cyberduck"
      "db-browser-for-sqlite"
      "dosbox"
      "mixxx"
      "wireshark-app"
      "obs"
      "prismlauncher"
      "ghidra"
      "stolendata-mpv"
      "yubico-authenticator"
      "openmtp"
    ];
    masApps = {
    };
  };

  services.yknotify-rs = {
    enable = true;

    # You can set notification sounds (find available sounds in `/System/Library/Sounds`):
    requestSound = "Purr";
    dismissedSound = "Pop";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.primaryUser = "tristan";
}

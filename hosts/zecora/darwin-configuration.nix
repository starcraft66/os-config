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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.primaryUser = "tristan";
}

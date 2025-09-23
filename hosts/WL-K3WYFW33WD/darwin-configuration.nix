{ config, pkgs, lib, inputs, ... }:

{
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
      config.my.deepBlackColors = true;
    };
  };

  homebrew = {
    brews = [
    ];
    taps = [
    ];
    casks = [
      "lens"
      "meetingbar"
      "orbstack"
      "jetbrains-toolbox"
    ];
    masApps = {
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.primaryUser = "tristan.g-hane";
}

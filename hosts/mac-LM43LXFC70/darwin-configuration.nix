{ config, pkgs, lib, inputs, ... }:

{
  users = {
    users."tgosselin-hane" = {
      home = "/Users/tgosselin-hane";
      isHidden = false;
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users."tgosselin-hane" = { ... }: {
      imports = [
        ../../home-manager/home.nix
        ../../home-manager/programs/abnormal.nix
      ];

      config.my.terminalFontSize = 18;
      config.my.deepBlackColors = true;
    };
  };

  homebrew = {
    brews = [
    ];
    taps = [
      "anomalyco/tap"
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
  system.primaryUser = "tgosselin-hane";
}

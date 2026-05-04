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
      # Disabled: lags the prompt horribly on this machine
      config.my.starship.python = false;
    };
  };

  homebrew = {
    taps = [
      "syncdk/aws-session-manager-plugin"
      "databricks/tap"
      "ankitpokhrel/jira-cli"
      "apono-io/tap"
      {
        name = "abnormal-security/abnormal";
        clone_target = "git@github.com:abnormal-security/homebrew-abnormal.git";
      }
    ];
    brews = [
      # docker needs brew on macOS (no Nix package for the daemon/CLI on darwin)
      "docker"
      # jenv, ruff-lsp not in nixpkgs
      "jenv"
      "ruff-lsp"
      # Python (scripts check for Homebrew Python specifically)
      "python@3.11"
      "virtualenv"
      # Python native library build deps (need to be in /opt/homebrew for compiler to find them)
      "openssl@3.0"
      "libpq"
      "mysql-client@8.0"
      "zbar"
      "librdkafka"
      "snappy"
      "hdf5"
      "freetype"
      "libpng"
      "apono-io/tap/apono-cli"
      # Databricks CLI (no nixpkg, custom tap)
      "databricks/tap/databricks"
      "ankitpokhrel/jira-cli/jira-cli"
      # Abnormal custom packages (private tap, no nixpkg)
      "abnormal-security/abnormal/cmake"
      "abnormal-security/abnormal/mupdf"
      "abnormal-security/abnormal/rocksdb"
    ];
    casks = [
      "lens"
      "meetingbar"
      "cursor"
      "syncdk/aws-session-manager-plugin/session-manager-plugin"
    ];
    masApps = {
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.primaryUser = "tgosselin-hane";
}

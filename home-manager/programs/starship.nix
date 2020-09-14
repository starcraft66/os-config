{ config, lib, pkgs, ... }:

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball {};
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;
in
{
  programs.starship = {
    # Use starship master so that I can get the new formatting syntax
    # before starship 0.45 is officially released

    package = unstable.starship.overrideAttrs (oldAttrs: rec {
      version = "0.44.999999999999999999";
      src = pkgs.fetchFromGitHub {
        owner = "starship";
        repo = oldAttrs.pname;
        rev = "2996220568d5dcc437b09dcfa2654a90c3ed9809";
        sha256 = "0qmpbl7kzv7ighh8vw71mmxzcfay6cls6ny3qc4mx87l2x3ywssb";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
        name = "${oldAttrs.pname}-${version}-vendor.tar.gz";
        inherit src;
        outputHash = "05cwvpagbqcwbnfjyb73dywvdhjl4jbj9vh1w6k977x2yh9vz7d8";
      });
      # Tests don't work on this dev version for some reason
      doCheck = false;
    });


    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;

    settings = {
      # This line replaces add_newline = false
      add_newline = false;
      format = "$all";
      prompt_order = [
        "username"
        "hostname"
        "git_branch"
        "git_commit"
        "git_state"
        "git_status"
        "hg_branch"
        "docker_context"
        "package"
        "dotnet"
        "elixir"
        "elm"
        "erlang"
        "golang"
        "haskell"
        "java"
        "julia"
        "nodejs"
        "ocaml"
        "php"
        "purescript"
        "python"
        "ruby"
        "rust"
        "terraform"
        "zig"
        "nix_shell"
        "conda"
        "memory_usage"
        "env_var"
        "crystal"
        "cmd_duration"
        "custom"
        "line_break"
        "jobs"
        "battery"
        "directory"
        "time"
        "character"
      ];

      character = {
        symbol = "$";
      };

      cmd_duration = {
        disabled = false;
        min_time = 10000;
      };

      directory = {
        disabled = false;
        prefix = "";
        truncation_length = 999;
        truncate_to_repo = false;
      };

      hostname = {
        ssh_only = false;
        style = "fg:purple";
        format = "@[$hostname]($style):";
      };

      line_break = {
        disabled = true;
      };

      nix_shell = {
        use_name = false;
        impure_msg = "";
        pure_msg = "";
        symbol = "❄️";
      };

      time = {
        disabled = true;
        format = "%H:%M";
        prefix = "";
      };

      username = {
        disabled = false;
        show_always = true;
        style_user = "fg:purple";
        style_root = "bold fg:red";
        format = "[$user]($style)";
      };

      gcloud = {
        disabled = true;
      };
    };
  };
}


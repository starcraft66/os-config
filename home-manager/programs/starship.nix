{ config, lib, pkgs, ... }:

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball {};
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;
in
{
  programs.starship = {
    enable = true;
    package = unstable.starship;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;

    settings = {
      # This line replaces add_newline = false
      add_newline = false;
      format = "$all";

      character = {
        symbol = "$";
      };

      cmd_duration = {
        disabled = false;
        min_time = 10000;
      };

      directory = {
        disabled = false;
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


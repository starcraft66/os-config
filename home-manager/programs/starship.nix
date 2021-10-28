{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;

    settings = {
      # This line replaces add_newline = false
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_commit$git_state$git_status$cmd_duration$jobs$status$character";

      cmd_duration = {
        disabled = false;
        min_time = 10000;
      };

      directory = {
        disabled = false;
        truncation_length = 1;
        fish_style_pwd_dir_length = 1;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "\\([$branch]($style)\\) ";
      };

      hostname = {
        ssh_only = false;
        style = "fg:purple";
        format = "[@$hostname]($style):";
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
        disabled = true;
        show_always = true;
        style_user = "fg:purple";
        style_root = "bold fg:red";
        format = "[$user]($style)";
      };
    };
  };
}


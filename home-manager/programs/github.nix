{ config, lib, pkgs, ... }:

{
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = false;
    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
}

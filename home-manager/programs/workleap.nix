{ config, lib, pkgs, ... }:

{
  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Workleap"
  '';

  programs.ssh.matchBlocks."*".identityAgent = [
    "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
  ];
}
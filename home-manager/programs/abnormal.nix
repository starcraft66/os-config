{ config, lib, pkgs, ... }:

let
  onePasswordSSHAgentSocket = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  home.packages = with pkgs; [
    # terraform
    # terragrunt
    tenv
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Abnormal"
  '';

  programs.ssh.matchBlocks."*".identityAgent = [
    (lib.escape [" "] onePasswordSSHAgentSocket)
  ];

  services.gpg-agent.enableSshSupport = lib.mkForce false;
  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkForce onePasswordSSHAgentSocket;
  };

  programs.jujutsu.settings.signing.backend = lib.mkForce "ssh";
  programs.jujutsu.settings.signing.key = lib.mkForce "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJX9CGbnEobiWvrIdts1nNvB0yu7AYjQ3bD5UC6YV1cx";
}

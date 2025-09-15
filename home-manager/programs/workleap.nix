{ config, lib, pkgs, ... }:

let
  onePasswordSSHAgentSocket = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Workleap"
  '';

  programs.ssh.matchBlocks."*".identityAgent = [
    (lib.escape [" "] onePasswordSSHAgentSocket)
  ];

  services.gpg-agent.enableSshSupport = lib.mkForce false;
  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkForce onePasswordSSHAgentSocket;
  };

  programs.jujutsu.settings.signing.backend = lib.mkForce "ssh";
  programs.jujutsu.settings.signing.key = lib.mkForce "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC27H6hu4WRtykvIpP+pCKUPSWPXdmFA8ly5MWBTUrUHTM+a77kA6xqsfD4CyFJ7oyCYbdKNSstnnwfHJNzQdUevErXkmpE86w+jbbUxWvl71r6pvVh5PufN+hlUoh7nxSGLH9qy+QJJ4hijs353T+dCO+xHbAEtWAnuxapgI3JNsUISa+9tAHWC/X5Ru0x8UnKJHbJN257ycPi6obF6soJVQLEcdt6N0dlcxMk7N6Cg1srGNxZo7lxKZLTSqTG1wWYyTCEpe5p6KfkXExRcL40e45d//PUTVI6cYsRW1EyXZwYkZoG/dNMlkk0RyOYVolzKZiyiIxmCe8nTOi3p0W2bYQ98jwI+cL2sRAYeC6ImQ8cWEP47x7U4pwnX2XN2QmsGno9dLEnZJf/1u2aomV3YbczemWsgPlEae0eFTI1X6y3WNVPkFOKHvJVvM39NOZCEgSr6/volqd0KPrRW8tzxB9z6MioyZQDuRQL76epQN5dWYyaXE0rNwUFlbGx7wIfjDy8LZHlMkgcUDpuvYD9CRWrqp6zcJ+ZzN98kpYF4PkbdDepttEyQW3oKRjolHuDR4TMY0gCQc6Cy9/HFKV4Si+WaRm2uiyfVOhqlhGfIRLrVlxgcd1VhriItl7en2btCn0ogmwSIg3jNtRikwnAJKo1urY1lJ/8joS5gHxk7Q==";
}
{ config, lib, pkgs, ... }:

let
  onePasswordSSHAgentSocket = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  home.packages = with pkgs; [
    # Terraform / Terragrunt version manager (replaces tfenv + tgenv)
    tenv
    awscli2
    # JVM
    jdk11
    maven
    # Python
    ruff
    # Python native build tools (binaries; the libraries stay in homebrew)
    pkg-config
    swig
    # Build toolchain
    bazelisk
    (pkgs.writeShellScriptBin "bazel" "${bazelisk}/bin/bazelisk \"$@\"")
    # Containers
    docker-buildx
    qemu
    # Cloud / registry
    regclient
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Abnormal"
  '';

  programs.ssh.matchBlocks."*".identityAgent = [
    (lib.escape [" "] onePasswordSSHAgentSocket)
  ];

  # Expose keg-only Homebrew packages that aren't linked by default
  home.sessionPath = [
    "/opt/homebrew/opt/libpq/bin"        # pg_config
    "/opt/homebrew/opt/mysql-client@8.0/bin" # mysql_config
  ];

  services.gpg-agent.enableSshSupport = lib.mkForce false;
  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkForce onePasswordSSHAgentSocket;
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    TERRAGRUNT_SOURCE_UPDATE = "true";
    TERRAGRUNT_SOURCE_MAP = "git::ssh://git@github.com/abnormal-security/infrastructure-modules.git=${config.home.homeDirectory}/src/infrastructure-modules";
  };

  programs.ghostty.settings.command = "${pkgs.zsh}/bin/zsh --login --interactive";

  programs.jujutsu.settings.signing.backend = lib.mkForce "ssh";
  programs.jujutsu.settings.signing.key = lib.mkForce "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJX9CGbnEobiWvrIdts1nNvB0yu7AYjQ3bD5UC6YV1cx";
}

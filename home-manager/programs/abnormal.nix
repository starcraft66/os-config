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
    # Language servers
    typescript-language-server
    gopls
    # Misc
    grpcurl
    sqlc
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Abnormal"
  '';

  programs.ssh.settings."*".IdentityAgent = [
    (lib.escape [" "] onePasswordSSHAgentSocket)
  ];

  # Expose keg-only Homebrew packages that aren't linked by default
  home.sessionPath = [
    "/opt/homebrew/opt/libpq/bin"            # pg_config
    "/opt/homebrew/opt/mysql-client@8.0/bin" # mysql_config
    "${config.home.homeDirectory}/.jenv/bin" # jenv shims
  ];

  home.activation.jenvSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _jenv=/opt/homebrew/bin/jenv
    if [ -x "$_jenv" ]; then
      $DRY_RUN_CMD sudo -u ${config.home.username} "$_jenv" add ${pkgs.jdk11} 2>/dev/null || true
      _jenv_version=$(sudo -u ${config.home.username} "$_jenv" versions --bare 2>/dev/null | grep -v "^system$" | head -1)
      if [ -n "$_jenv_version" ]; then
        $DRY_RUN_CMD sudo -u ${config.home.username} "$_jenv" global "$_jenv_version" || true
      fi
      $DRY_RUN_CMD sudo -u ${config.home.username} /bin/bash -c '
        eval "$(/opt/homebrew/bin/jenv init -)" 2>/dev/null
        jenv enable-plugin export 2>/dev/null || true
        jenv enable-plugin maven 2>/dev/null || true
      '
    fi
  '';

  services.gpg-agent.enableSshSupport = lib.mkForce false;
  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkForce onePasswordSSHAgentSocket;
    DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    TERRAGRUNT_SOURCE_UPDATE = "true";
    TERRAGRUNT_SOURCE_MAP = "git::ssh://git@github.com/abnormal-security/infrastructure-modules.git=${config.home.homeDirectory}/src/infrastructure-modules";
  };

  programs.ghostty.settings.command = "${pkgs.zsh}/bin/zsh --login --interactive";

  programs.zsh.initContent = ''
    [ -x /opt/homebrew/bin/jenv ] && eval "$(jenv init -)"
    export SOURCE="${config.home.homeDirectory}/src/source"
    export VENV="$SOURCE/.venv"
    if [ -d "$SOURCE" ]; then
      . "$SOURCE/tools/bash/prelude.sh"
      . "$SOURCE/tools/dev/common_bash_includes"
    fi
  '';

  programs.jujutsu.settings.signing.backend = lib.mkForce "ssh";
  programs.jujutsu.settings.signing.key = lib.mkForce "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJX9CGbnEobiWvrIdts1nNvB0yu7AYjQ3bD5UC6YV1cx";
}

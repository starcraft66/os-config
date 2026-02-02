{ inputs, pkgs, osConfig, config, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      use ${inputs.bash-env-nushell.packages.${pkgs.stdenv.system}.default}/bash-env.nu
      bash-env ${osConfig.system.build.setEnvironment} | load-env
      bash-env ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh | load-env
      mkdir ($nu.data-dir | path join "vendor/autoload")
      tv init nu | save -f ($nu.data-dir | path join "vendor/autoload/tv.nu")

      $env.config.edit_mode = "vi"
      $env.config.buffer_editor = "nvim"
      $env.EDITOR = "nvim"
      $env.PROMPT_INDICATOR_VI_NORMAL = ""
      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.config.cursor_shape.vi_insert = "line"
      $env.config.cursor_shape.vi_normal = "block"
      $env.config.cursor_shape.emacs = "line"

      source "${inputs.kubectl-aliases + "/.kubectl_aliases.nu"}"
    '';
  };
}

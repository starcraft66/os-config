{ inputs, pkgs, osConfig, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      use ${inputs.bash-env-nushell.packages.${pkgs.stdenv.system}.default}/bash-env.nu
      bash-env ${osConfig.system.build.setEnvironment} | load-env
      bash-env /etc/profiles/per-user/tristan.g-hane/etc/profile.d/hm-session-vars.sh | load-env
      mkdir ($nu.data-dir | path join "vendor/autoload")
      tv init nu | save -f ($nu.data-dir | path join "vendor/autoload/tv.nu")

      # Can be removed once https://github.com/NixOS/nixpkgs/pull/439871 is merged
      # Background-agnostic theme:
      # use std
      # $env.config.color_config = (
      #   std config dark-theme | transpose key val | update val {|line|
      #     if ($line.val | describe) == string {
      #       $line.val | std str replace "white" "default"
      #     } else {
      #       $line.val
      #     }
      #   } | transpose -rd
      # )
    '';
  };
}

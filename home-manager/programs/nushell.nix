{ ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      mkdir ($nu.data-dir | path join "vendor/autoload")
      tv init nu | save -f ($nu.data-dir | path join "vendor/autoload/tv.nu")
    '';
  };
}
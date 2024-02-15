{ pkgs, config, lib, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in (lib.mkIf isLinux (with lib; {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-nvfbc
      obs-move-transition
      obs-pipewire-audio-capture
    ];
  };
}))

{ pkgs, osConfig, config, lib, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in (lib.mkIf isLinux (with lib; {
  programs.obs-studio = {
    enable = true;
    package = lib.mkIf (elem "nvidia" osConfig.services.xserver.videoDrivers) (pkgs.obs-studio.override { cudaSupport = true; });
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-move-transition
      obs-pipewire-audio-capture
    ];
  };
}))

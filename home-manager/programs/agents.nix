{ lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  # On darwin, we install these via brew
  (lib.mkIf isLinux {
    home.packages = with pkgs; [
      claude-code
      codex
      opencode
    ];
  })
]

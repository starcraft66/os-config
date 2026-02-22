{ lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  # On darwin, we install these via brew
  (lib.mkIf isLinux {
    home.packages = with pkgs; [
      claude-code
      # Always use the most up-to-date version of opencode from the upstream flake
      inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    ];
  })
]

# (import (fetchTarball https://github.com/edolstra/flake-compat/archive/master.tar.gz) {
#   src = builtins.fetchGit ./.;
# }).shellNix

{ pkgs ? import <nixpkgs> {  } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ git nixFlakes ];

  NIX_CONF_DIR = let
    current = pkgs.lib.optionalString (builtins.pathExists /etc/nix/nix.conf) (builtins.readFile /etc/nix/nix.conf);
    nixConf = pkgs.writeTextDir "etc/nix.conf" ''
      ${current}
      experimental-features = nix-command flakes
    '';
  in "${nixConf}/etc";
}

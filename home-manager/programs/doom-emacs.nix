{ config, lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  {
    home.packages = with pkgs; [
      nodePackages.pyright
      yaml-language-server
    ];

    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ../doom.d;
      emacsPackage = pkgs.emacsGit;
    };
  }
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
    };
  })
]

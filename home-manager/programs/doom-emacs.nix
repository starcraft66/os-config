{ config, lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  {
  # imports = [
  #   inputs.nix-doom-emacs.hmModule
  # ];

  home.packages = with pkgs; [
    nodePackages.pyright
    yaml-language-server
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
  };

  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';
  }
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
    };
  })
]

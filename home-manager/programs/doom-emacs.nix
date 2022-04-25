{ config, lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  {
    home.packages = with pkgs; [
      nodePackages.pyright
      yaml-language-server
      terraform-ls
      rust-analyzer
      elixir_ls
      erlang-ls
    ];

    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ../doom.d;
      emacsPackage = pkgs.emacs28;
    };
  }
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
    };
    systemd.user.services.emacs = {
      Unit.PartOf = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session-pre.target" ];
      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
    };
  })
]

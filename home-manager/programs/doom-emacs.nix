{ config, lib, pkgs, inputs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  DOOMDIR = "${config.xdg.configHome}/doom";
  DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/cache/profile-load.el";
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
      nodejs
    ];

    programs.emacs = {
      enable = true;
      package = lib.mkMerge [
        (lib.mkIf isLinux (pkgs.emacs29-pgtk.override { withTreeSitter = true; withNativeCompilation = true; }))
        (lib.mkIf isDarwin (pkgs.emacs29.override { withTreeSitter = true; withNativeCompilation = true; }))
      ];
      extraPackages = epkgs: with epkgs; [
        vterm
      ];
    };

    home.sessionVariables = {
      inherit DOOMLOCALDIR DOOMDIR DOOMPROFILELOADFILE;
    };
    systemd.user.sessionVariables = lib.mkIf isLinux {
      inherit DOOMLOCALDIR DOOMDIR DOOMPROFILELOADFILE;
    };

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    xdg.configFile."doom" = {
      source = pkgs.applyPatches {
        name = "doom-emacs-dotfiles";
        src = ../doom.d;
        patches = [
          # (pkgs.substituteAll {
          #   src = ./doom.d/envrc-package.patch;
          #   envrc_direnv_package = "${config.programs.direnv.package or pkgs.direnv}/bin/direnv";
          # })
        ];
      };
      force = true;
    };

    # Create this folder for the $DOOMPROFILELOADFILE file
    xdg.dataFile."doom/cache/.keep".text = "";

    xdg.configFile."emacs" = {
      source = pkgs.applyPatches {
        name = "doom-emacs-source";
        src = inputs.doom-emacs;
        # No longer necessary since https://github.com/hlissner/doom-emacs/commit/1c1ad3a8c8b669b6fa20b174b2a4c23afa85ec24
        # Just pass "--no-hooks" when installing Doom Emacs
        # patches = [ ./doom.d/disable_install_hooks.patch ];
      };
      force = true;
    };
  }
  (lib.mkIf isLinux {
    services.emacs = {
      enable = true;
      client.enable = false;
    };
    systemd.user.services.emacs = {
      Unit.PartOf = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session-pre.target" ];
      Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
    };
  })
]

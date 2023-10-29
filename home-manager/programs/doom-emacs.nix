{ config, lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  imports = [inputs.nix-doom-emacs.hmModule];
} // lib.mkMerge [
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

    programs.doom-emacs = rec {
      enable = true;
      doomPrivateDir = ../doom.d;
      emacsPackage = (pkgs.emacs29.override { withPgtk = true; });
      # Only init/packages so we only rebuild when those change.
      doomPackageDir = let
        filteredPath = builtins.path {
          path = doomPrivateDir;
          name = "doom-private-dir-filtered";
          filter = path: type:
            builtins.elem (baseNameOf path) [ "init.el" "packages.el" ];
        };
      in pkgs.linkFarm "doom-packages-dir" [
        {
          name = "init.el";
          path = "${filteredPath}/init.el";
        }
        {
          name = "packages.el";
          path = "${filteredPath}/packages.el";
        }
        {
          name = "config.el";
          path = pkgs.emptyFile;
        }
      ];
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

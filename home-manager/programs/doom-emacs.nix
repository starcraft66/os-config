{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/vlaci/nix-doom-emacs";
    rev = "df31ca1bf11b199a47d6ebcc0c9bb64a4ff365e4";
  }) {
    doomPrivateDir = ../doom.d;  # Directory containing your config.el init.el and packages.el files
  };
  unstable = import <nixos-unstable> {};
in {
  home.packages = with unstable.pkgs; [
    python-language-server
    yaml-language-server
  ];
 services.emacs.enable = true;
 programs.emacs = {
   enable = true;
   package = doom-emacs;
 };
 home.file.".emacs.d/init.el".text = ''
     (load "default.el")
 '';
}

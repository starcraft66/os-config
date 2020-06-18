{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/vlaci/nix-doom-emacs";
    rev = "9337a8741ea79084642a430c4b01814377530424";
  }) {
    doomPrivateDir = ../doom.d;  # Directory containing your config.el init.el and packages.el files
  };
in {
 home.packages = [ doom-emacs ];
 home.file.".emacs.d/init.el".text = ''
     (load "default.el")
 '';
}
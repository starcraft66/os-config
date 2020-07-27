{ pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/vlaci/nix-doom-emacs";
    rev = "8176d34e198ea5b12d15841220150c44310d5bea";
    ref = "issue/14";
  }) {
    doomPrivateDir = ../doom.d;  # Directory containing your config.el init.el and packages.el files
  };
in {
 home.packages = [ doom-emacs ];
 home.file.".emacs.d/init.el".text = ''
     (load "default.el")
 '';
}
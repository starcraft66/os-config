{ pkgs, inputs, ... }:

{
  # imports = [
  #   inputs.nix-doom-emacs.hmModule
  # ];
  #lolb182af7d10aa8394f12ecc2c53fd942fa30de060

  home.packages = with pkgs; [
    python-language-server
    yaml-language-server
  ];

  services.emacs = {
    enable = true;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
  };

  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';
}

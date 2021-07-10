{ config, lib, pkgs, inputs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # Pin nixpkgs for older Nix tools
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      emacs-overlay.flake = inputs.emacs-overlay;
    };
  };
}

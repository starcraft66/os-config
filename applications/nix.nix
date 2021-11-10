{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../caches/nix-community.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    # Pin nixpkgs for older Nix tools
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      emacs-overlay.flake = inputs.emacs-overlay;
    };
  };
  environment.systemPackages = with pkgs; [ nixfmt ];
}

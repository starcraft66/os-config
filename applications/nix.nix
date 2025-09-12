{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../caches/nix-community.nix
    ../caches/devenv.nix
    ../caches/cosmic.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      keep-outputs = true;
      keep-derivations = true;
      builders-use-substitutes = true;

      # nop out the global flake registry
      flake-registry = "${pkgs.writeText "flake-registry" (builtins.toJSON { version = 2; flakes = [ ]; })}";
    };
    # Pin nixpkgs for older Nix tools
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      emacs-overlay.flake = inputs.emacs-overlay;
    };
  };
  environment.systemPackages = with pkgs; [ nixfmt-rfc-style nixpkgs-fmt nixd ];
}

{ config, lib, pkgs, inputs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      # Workaround: remove once nixpkgs contains a nix-direnv version newer than 3.2.0.
      package = inputs.nix-direnv.packages.${pkgs.system}.default;
    };
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}

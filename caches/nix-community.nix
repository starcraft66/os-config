{lib, pkgs, ...}:

let
  caches = [
    "https://nix-community.cachix.org"
  ];
  publicKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
in
{
  nix.settings = {
    binary-caches = caches;
    binary-cache-public-keys = publicKeys;
  };
}

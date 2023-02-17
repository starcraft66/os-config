{lib, pkgs, ...}:

let
  caches = [
    "https://devenv.cachix.org"
  ];
  publicKeys = [
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
  ];
in
{
  nix.settings = {
    binary-caches = caches;
    binary-cache-public-keys = publicKeys;
  };
}

{lib, pkgs, ...}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  caches = [
    "https://nix-community.cachix.org"
  ];
  publicKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  nixLinux = {
    binary-caches = caches;
    binary-cache-public-keys = publicKeys;
  };
  nixDarwin = {
    binaryCaches = caches;
    binaryCachePublicKeys = publicKeys;
  };
in
{
  nix = if isLinux then nixLinux
    else if isDarwin then nixDarwin
    else lib.throw "Unknown operating system!!!";
}

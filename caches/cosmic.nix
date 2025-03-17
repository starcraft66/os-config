{lib, pkgs, ...}:

let
  caches = [
    "https://cosmic.cachix.org"
  ];
  publicKeys = [
    "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  ];
in
{
  nix.settings = {
    binary-caches = caches;
    binary-cache-public-keys = publicKeys;
  };
}

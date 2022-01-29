{
  nix.settings = {
    binary-caches = [
      "https://nix-community.cachix.org"
    ];
    binary-cache-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}

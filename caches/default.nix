let
  caches = [
    {
      url = "https://cosmic.cachix.org";
      publicKey = "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=";
    }
    {
      url = "https://devenv.cachix.org";
      publicKey = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    }
    {
      url = "https://nix-community.cachix.org";
      publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    {
      url = "https://lanzaboote.cachix.org";
      publicKey = "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk=";
    }
    {
      url = "https://hyprland.cachix.org";
      publicKey = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    }
    {
      url = "https://ghostty.cachix.org";
      publicKey = "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=";
    }
    {
      url = "https://colmena.cachix.org";
      publicKey = "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg=";
    }
  ];
in
{
  nix.settings = {
    substituters = map (cache: cache.url) caches;
    trusted-public-keys = map (cache: cache.publicKey) caches;
  };
}

with import <nixpkgs> {};

mkShell {
  sopsPGPKeyDirs = [ 
    "./secrets/keys/hosts"
    "./secrets/keys/users"
  ];
  nativeBuildInputs = [
     (pkgs.callPackage <sops-nix> {}).sops-pgp-hook
  ];
}

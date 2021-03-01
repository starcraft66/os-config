{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, sops-nix, home-manager, nix-doom-emacs, ... }: {
    nixosConfigurations = {
      luna = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.users.tristan = {pkgs, ...}: {
              imports = [ nix-doom-emacs.hmModule ];
            };
          }
          sops-nix.nixosModules.sops
          ./hosts/luna/configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
      helia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.users.tristan = {pkgs, ...}: {
              imports = [ nix-doom-emacs.hmModule ];
            };
          }
          sops-nix.nixosModules.sops
          ./hosts/helia/configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
    darwinConfigurations = {
      NightmareMoon = inputs.nix-darwin.lib.darwinSystem {
        modules = [ ./hosts/nightmaremoon/darwin-configuration.nix ];
      };
    };
    devShell.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    pkgs.mkShell {
      nativeBuildInputs = with pkgs; [ git nixFlakes ];

      NIX_CONF_DIR = let
        current = pkgs.lib.optionalString (builtins.pathExists /etc/nix/nix.conf) (builtins.readFile /etc/nix/nix.conf);
        nixConf = pkgs.writeTextDir "etc/nix.conf" ''
          ${current}
          experimental-features = nix-command flakes
        '';
      in "${nixConf}/etc";
    };
  };
}

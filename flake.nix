{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/master";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    nixos-nvidia-vgpu.url = "github:danielfullmer/nixos-nvidia-vgpu";
  };
  outputs = inputs@{ self, nixos, nix-darwin, nixpkgs, sops-nix, home-manager, nix-doom-emacs, nixos-nvidia-vgpu, ... }: let
    inherit (nixpkgs) lib;

    platforms = [ "x86_64-linux" "x86_64-darwin" ];

    forAllPlatforms = f: lib.genAttrs platforms (platform: f platform);

    nixpkgsFor = forAllPlatforms (platform: import nixpkgs {
      system = platform;
      # overlays = builtins.attrValues self.overlays;
      config.allowUnfree = true;
    });
  in {

    devShell = forAllPlatforms (platform: let
        pkgs = nixpkgsFor.${platform};
      in pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ git nixFlakes ];

        NIX_CONF_DIR = let
          current = lib.optionalString (builtins.pathExists /etc/nix/nix.conf) (builtins.readFile /etc/nix/nix.conf);
          nixConf = pkgs.writeTextDir "etc/nix.conf" ''
            ${current}
            experimental-features = nix-command flakes
          '';
        in "${nixConf}/etc";
      });

    nixosConfigurations = {
      luna = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.users.tristan = {pkgs, ...}: {
              imports = [ nix-doom-emacs.hmModule ];
            };
          }
          sops-nix.nixosModules.sops
          nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
          ./hosts/luna/configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
      helia = nixos.lib.nixosSystem {
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
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.users.tristan = {pkgs, ...}: {
              imports = [ nix-doom-emacs.hmModule ];
            };
          }
          ./hosts/nightmaremoon/darwin-configuration.nix
        ];
        specialArgs = { inputs = inputs // { darwin = inputs.nix-darwin; }; };
      };
    };
  };
}

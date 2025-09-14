{  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    doom-emacs.url = "github:hlissner/doom-emacs";
    doom-emacs.flake = false;

    nixos-nvidia-vgpu.url = "github:danielfullmer/nixos-nvidia-vgpu";

    nixd.url = "github:nix-community/nixd";
    nixd.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland/v0.40.0";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    kubectl-aliases.url = "github:ahmetb/kubectl-aliases";
    kubectl-aliases.flake = false;
    
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    determinate.inputs.nixpkgs.follows = "nixpkgs";
    
    mac-app-util.url = "github:hraban/mac-app-util";
    mac-app-util.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nix-darwin, nix-homebrew, nixpkgs, nixpkgs-stable, nixos-wsl, sops-nix, home-manager, nixos-nvidia-vgpu, nixd, hyprland, vscode-server, lanzaboote, determinate, mac-app-util, ... }: let
    inherit (nixpkgs) lib;

    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

    forAllPlatforms = f: lib.genAttrs platforms (platform: f platform);

    # inlined LOL
    nixosSystem' = args:
      import "${nixpkgs}/nixos/lib/eval-config.nix" (args // {
        modules = args.modules ++ [ {
          system.nixos.versionSuffix = ".${lib.substring 0 8 (nixpkgs.lastModifiedDate or nixpkgs.lastModified or "19700101")}.${nixpkgs.shortRev or "dirty"}";
          system.nixos.revision = lib.mkIf (nixpkgs ? rev) nixpkgs.rev;
        } ];
      });

    nixpkgsFor = forAllPlatforms (platform:
      import nixpkgs {
        system = platform;
        config.allowUnfree = true;
        overlays = lib.flatten [
          (lib.optional (platform == "x86_64-linux")
          (self: super: {
            # Use packages from stable because they are broken on unstable
            # inherit (nixpkgs-stable.legacyPackages.${platform}) azure-cli;
            azure-cli = super.azure-cli.overrideAttrs (old: {
              patches = (old.patches or []) ++ [
                (self.fetchpatch { # https://github.com/NixOS/nixpkgs/pull/436682
                  url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/436682.patch";
                  sha256 = "sha256-RHV36R5Dpxw5qUtGgy98xvHxs4u9Tr110FImYpYoNd0=";
                })
              ];
            });
            # python39Packages = super.python39Packages // { inherit (nixpkgs-stable.legacyPackages.${platform}.python39Packages) h2; };
          }))
          inputs.emacs-overlay.overlay
          inputs.nixd.overlays.default
          # Apple Silicon backport overlay:
          # In other words, x86 packages to install instead of
          # arm packages which don't build yet for any reason
          (lib.optional (platform == "aarch64-darwin")
          # Apple Silicon backport overlay:
          # In other words, x86 packages to install instead of
          # arm packages which don't build yet for any reason
          (self: super: {
            # This is bad for libraries but okay for programs.
            # See: https://github.com/LnL7/nix-darwin/issues/334#issuecomment-850857148
            # For libs, I will use pkgsX86 defined below.
            # inherit (nixpkgsX86darwin) kitty;
          }))
        ];
      });

    nixpkgsX86darwin = import nixpkgs {
      localSystem = "x86_64-darwin";
    };
  in {

    devShells = forAllPlatforms (platform: let
        pkgs = nixpkgsFor.${platform};
        sops = inputs.sops-nix.packages.${platform};

        NIX_CONF_DIR = (pkgs.writeTextDir "etc/nix.conf" ''
          experimental-features = nix-command flakes
          !include /etc/nix/nix.conf
          # include /etc/nix/doesnt-exist-nix.conf
        '') + "/etc";
      in { default = pkgs.mkShell {
        sopsPGPKeyDirs = [
          "./secrets/keys/hosts"
          "./secrets/keys/users"
        ];

        nativeBuildInputs = with pkgs; [
          git
          nixfmt-rfc-style
          sops.sops-import-keys-hook
        ];

        shellHook = ''
          export NIX_CONF_DIR=${NIX_CONF_DIR}
        '';
      }; });

    nixosConfigurations = {
      luna = let
        system = "x86_64-linux";
      in nixosSystem' {
        system = system;
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
          hyprland.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          ./modules
          ./hosts/luna/configuration.nix
        ];
        pkgs = nixpkgsFor.${system};
        specialArgs = { inherit inputs; };
      };
      helia = let
        system = "x86_64-linux";
      in nixosSystem' {
        system = system;
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          ./hosts/helia/configuration.nix
        ];
        pkgs = nixpkgsFor.${system};
        specialArgs = { inherit inputs; };
      };
    };
    darwinConfigurations = let
      commonDarwinModules = [
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        determinate.darwinModules.default
        mac-app-util.darwinModules.default
        {
          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
          ];
        }
      ];
    in {
      WL-K3WYFW33WD = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = commonDarwinModules ++ [
          ./hosts/WL-K18WYFW33WD/darwin-configuration.nix
        ];
        specialArgs = {
          # Was having trouble getting nix to serve me arm64 packages
          # so we are being explicit here :)
          pkgs = nixpkgsFor.aarch64-darwin;
          # Rosetta 2 is installed, define a special pkgsX86 to install
          # packages that don't build on aarch64-darwin yet as a fallback
          pkgsX86 = nixpkgsX86darwin;
          inputs = inputs // { darwin = inputs.nix-darwin; };
        };
      };
      Zecora = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = commonDarwinModules ++ [
          ./hosts/zecora/darwin-configuration.nix
        ];
        specialArgs = {
          # Was having trouble getting nix to serve me arm64 packages
          # so we are being explicit here :)
          pkgs = nixpkgsFor.aarch64-darwin;
          # Rosetta 2 is installed, define a special pkgsX86 to install
          # packages that don't build on aarch64-darwin yet as a fallback
          pkgsX86 = nixpkgsX86darwin;
          inputs = inputs // { darwin = inputs.nix-darwin; };
        };
      };
    };
  };
}

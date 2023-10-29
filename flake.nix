{
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.05";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # Fix for emacs 29/pgtk hanging on rebuild
    nix-straight.url = "github:codingkoi/nix-straight.el?ref=codingkoi/apply-librephoenixs-fix";
    nix-straight.flake = false;
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.inputs.nix-straight.follows = "nix-straight";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    nixos-nvidia-vgpu.url = "github:danielfullmer/nixos-nvidia-vgpu";
    devenv.url = "github:cachix/devenv/latest";
    nixd.url = "github:nix-community/nixd";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-stable, sops-nix, home-manager, nix-doom-emacs, nixos-nvidia-vgpu, devenv, nixd, ... }: let
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

    patchedNixpkgs = forAllPlatforms (platform: let
        originalNixpkgs = (import nixpkgs { system = platform; });
      in originalNixpkgs.applyPatches {
        name = "patched-nixpkgs";
        src = nixpkgs;
        patches = [
        # (originalNixpkgs.fetchpatch { # https://github.com/NixOS/nixpkgs/pull/223593
        #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/223593.patch";
        #   sha256 = "sha256-8Acdn2qy5/rSsvcXpYjlzgS8/1jDPAFcFLp8d76p7Ig=";
        # })
        ];
      });


    nixpkgsFor = forAllPlatforms (platform: let
      nixpkgsToImport =
        if (builtins.elem platform [ "x86_64-darwin" "aarch64-darwin" ])
        then lib.trace "using original nixpkgs" nixpkgs
        else lib.trace "building patched nixpkgs" patchedNixpkgs.${platform};
    in (import nixpkgsToImport {
        system = platform;
        overlays = lib.flatten [
          (lib.optional (platform == "x86_64-linux")
          (self: super: {
            # Use packages from stable because they are broken on unstable
            inherit (nixpkgs-stable.legacyPackages.${platform}) azure-cli;
            # python39Packages = super.python39Packages // { inherit (nixpkgs-stable.legacyPackages.${platform}.python39Packages) h2; };

          }))
          inputs.emacs-overlay.overlay
          inputs.nixd.overlays.default
          (self: super: {
            inherit (devenv.packages.${platform}) devenv;
          })
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
        config.allowUnfree = true;
      }));

    nixpkgsX86darwin = import nixpkgs {
      localSystem = "x86_64-darwin";
    };
  in {

    devShell = forAllPlatforms (platform: let
        pkgs = nixpkgsFor.${platform};
        sops = inputs.sops-nix.packages.${platform};

        NIX_CONF_DIR = (pkgs.writeTextDir "etc/nix.conf" ''
          experimental-features = nix-command flakes
          !include /etc/nix/nix.conf
          # include /etc/nix/doesnt-exist-nix.conf
        '') + "/etc";
      in pkgs.mkShell {
        sopsPGPKeyDirs = [
          "./secrets/keys/hosts"
          "./secrets/keys/users"
        ];

        nativeBuildInputs = with pkgs; [
          git
          nixfmt
          sops.sops-import-keys-hook
        ];

        shellHook = ''
          export NIX_CONF_DIR=${NIX_CONF_DIR}
        '';
      });

    nixosConfigurations = {
      luna = let
        system = "x86_64-linux";
      in nixosSystem' {
        system = system;
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
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
    darwinConfigurations = {
      NightmareMoon = inputs.nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/nightmaremoon/darwin-configuration.nix
        ];
        specialArgs = {
          pkgs = nixpkgsFor.x86_64-darwin;
          inputs = inputs // { darwin = inputs.nix-darwin; };
        };
      };
      CocoPommel = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/cocopommel/darwin-configuration.nix
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

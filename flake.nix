{
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    doom-emacs = { url = "github:hlissner/doom-emacs/develop"; flake = false; };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.inputs.doom-emacs.follows = "doom-emacs";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    nixos-nvidia-vgpu.url = "github:danielfullmer/nixos-nvidia-vgpu";
  };
  outputs = inputs@{ self, nixos, nix-darwin, nixpkgs, sops-nix, home-manager, nix-doom-emacs, nixos-nvidia-vgpu, ... }: let
    inherit (nixpkgs) lib;

    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

    forAllPlatforms = f: lib.genAttrs platforms (platform: f platform);

    nixpkgsFor = forAllPlatforms (platform: nixpkgs: import nixpkgs {
      system = platform;
      overlays = lib.flatten [
        (lib.optional (platform == "x86_64-linux")
        (self: super: {
          # Compile Mixxx using a PortAudio build that supports JACK
          # Overriding PortAudio globally causes an expensive rebuild I want to avoid
          # until the change is merged upstream
          # https://github.com/NixOS/nixpkgs/pull/157561
          mixxx = super.mixxx.override {
            portaudio = super.portaudio.overrideAttrs (oldPortaudioAttrs: {
              buildInputs = oldPortaudioAttrs.buildInputs ++ [ super.jack2 ];
            });
          };
        }))
        inputs.emacs-overlay.overlay
        # Apple Silicon backport overlay:
        # In other words, x86 packages to install instead of
        # arm packages which don't build yet for any reason
        (lib.optional (platform == "aarch64-darwin")
        # Apple Silicon backport overlay:
        # In other words, x86 packages to install instead of
        # arm packages which don't build yet for any reason
        (self: super: {
          starship = super.starship.overrideAttrs (oldAttrs: rec {
            pname = "starship";

            version = "1.1.1";

            src = super.fetchFromGitHub {
              owner = "starship";
              repo = pname;
              rev = "v${version}";
              sha256 = "sha256-Rr0HCr/uJDsBQiKJIPdEL3WOaLgMY2Nq2JGOq4dEUxQ=";
            };

            cargoDeps = oldAttrs.cargoDeps.overrideAttrs (super.lib.const {
              name = "${pname}-vendor.tar.gz";
              inherit src;
              outputHash = "sha256-Wt10f2T+uJx62z/rHmyylad6pvUsXDHX+QyhQjjB8eg=";
            });
          });
          # This is bad for libraries but okay for programs.
          # See: https://github.com/LnL7/nix-darwin/issues/334#issuecomment-850857148
          # For libs, I will use pkgsX86 defined below.
          # inherit (nixpkgsX86darwin) kitty;
        }))
      ];
      config.allowUnfree = true;
    });

    nixpkgsX86darwin = import nixpkgs {
      localSystem = "x86_64-darwin";
    };
  in {

    devShell = forAllPlatforms (platform: let
        pkgs = nixpkgsFor.${platform} inputs.nixpkgs;
        sops = inputs.sops-nix.packages.${platform};
      in pkgs.mkShell {
        sopsPGPKeyDirs = [
          "./secrets/keys/hosts"
          "./secrets/keys/users"
        ];

        nativeBuildInputs = with pkgs; [
          git
          nixFlakes
          nixfmt
          sops.sops-import-keys-hook
        ];

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
          ./modules
          ./hosts/luna/configuration.nix
        ];
        pkgs = nixpkgsFor.x86_64-linux nixos;
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
        pkgs = nixpkgsFor.x86_64-linux nixos;
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
        specialArgs = {
          pkgs = nixpkgsFor.x86_64-darwin inputs.nixpkgs;
          inputs = inputs // { darwin = inputs.nix-darwin; };
        };
      };
      CocoPommel = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.users."tristan.gosselin-hane" = {pkgs, ...}: {
              imports = [ nix-doom-emacs.hmModule ];
            };
          }
          ./hosts/cocopommel/darwin-configuration.nix
        ];
        specialArgs = {
          # Was having trouble getting nix to serve me arm64 packages
          # so we are being explicit here :)
          pkgs = nixpkgsFor.aarch64-darwin inputs.nixpkgs;
          # Rosetta 2 is installed, define a special pkgsX86 to install
          # packages that don't build on aarch64-darwin yet as a fallback
          pkgsX86 = nixpkgsX86darwin;
          inputs = inputs // { darwin = inputs.nix-darwin; };
        };
      };
    };
  };
}

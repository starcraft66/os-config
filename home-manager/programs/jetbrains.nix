{ config, osConfig, lib, pkgs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  (lib.mkIf isLinux (let
    # GitHub Copilot
    # nix-ld is required to run the copilot plugin
    ides = let
      NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
        stdenv.cc.cc
      ];
      withNixLd = (pkg: executable:
        pkgs.writeShellScriptBin executable ''
          export NIX_LD_LIBRARY_PATH=${NIX_LD_LIBRARY_PATH}
          export NIX_LD=$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)
          export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
          exec ${pkg}/bin/${executable} "$@"
        '');
    in with pkgs; [
      # Don't use these anymore but they're here to uncomment in case I need anything jetbrains
      # (withNixLd jetbrains.idea-ultimate "idea-ultimate")
      # (withNixLd jetbrains.clion "clion")
      # (withNixLd android-studio "android-studio")
    ];
  in {
    home.packages = ides;
  }))
]

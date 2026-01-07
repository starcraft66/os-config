{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  # Install azure cli extensions
  azure-cli = pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [
    aks-preview
  ]);
in
{
  home.packages = (with pkgs; [
    just
    kubelogin
    kubelogin-oidc
    opentofu
    powershell
    openssl
    yq
    vault
  ] ++ lib.optionals isDarwin [
    colima
  ]) ++ [
    azure-cli
  ];
}

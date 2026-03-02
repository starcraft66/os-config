{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  home.packages = (with pkgs; [
    just
    kubelogin
    kubelogin-oidc
    # opentofu
    powershell
    openssl
    yq-go
    vault
  ] ++ lib.optionals isDarwin [
    colima
  ]);
}

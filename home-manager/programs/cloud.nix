{ config, pkgs, lib, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  home.packages = with pkgs; [ azure-cli kubelogin opentofu powershell openssl yq vault ] ++ lib.optionals isDarwin [ colima ];
}

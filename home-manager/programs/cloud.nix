{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [ azure-cli kubelogin opentofu powershell openssl yq vault ];
}

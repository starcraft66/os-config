{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    kubectl kubie kubetail k9s kubeconform kubeswitch
    kubespy kubernetes-helm kube-capacity kubent
    ripgrep terraform opentofu kubectx jq
    kind kubebuilder
  ];

  programs.zsh.initContent = lib.mkOrder 2000 ''
    source <(kubectl completion zsh)
  '';
}

{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    kubectl kubie kubetail k9s kubeconform kubeswitch
    kubespy kubernetes-helm kube-capacity kubent
    ripgrep terraform opentofu kubectx
  ];

  programs.zsh.initExtra = ''
    source <(kubectl completion zsh)
  '';
}

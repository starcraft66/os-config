{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    kubectl kubie kubetail k9s kubeconform kubeswitch
    kubespy kube-capacity kubent
    ripgrep kubectx jq
    kind kubebuilder
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-git
      ];
    })
  ];

  programs.zsh.initContent = lib.mkOrder 2000 ''
    source <(kubectl completion zsh)
  '';
}

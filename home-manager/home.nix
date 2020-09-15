{ pkgs, ... }:

{
  imports = [
    ./programs/alacritty.nix
    ./programs/direnv.nix
    ./programs/doom-emacs.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/kde.nix
    ./programs/neofetch.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  programs.home-manager.enable = true;

}

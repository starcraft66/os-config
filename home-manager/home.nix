{ pkgs, lib, config, ... }:

{
  imports = [
    ./programs/alacritty.nix
    ./programs/direnv.nix
    ./programs/doom-emacs.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/i3.nix
    ./programs/kde.nix
    ./programs/neofetch.nix
    ./programs/obs-studio.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/vim.nix
# VSCode behaves horribly with a read-only config
#    ./programs/vscode.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  config.programs.home-manager.enable = true;

  options.my.terminalFontSize = lib.mkOption {
    description = "The terminal font size";
    type = lib.types.int;
  };

  options.my.ckb = lib.mkOption {
    description = "Autostart ckb-next daemon";
    default = false;
    type = lib.types.bool;
  };

  options.my.dpi = lib.mkOption {
    description = "DPI scale";
    default = 96;
    type = lib.types.int;
  };

}

{ pkgs, lib, config, ... }:

{
  imports = [
    ./programs/alacritty.nix
    ./programs/direnv.nix
    ./programs/doom-emacs.nix
    ./programs/dunst.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/gtk.nix
    ./programs/i3.nix
    ./programs/kitty.nix
    ./programs/neofetch.nix
    ./programs/nextcloud-client.nix
    ./programs/obs-studio.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/udiskie.nix
    ./programs/vim.nix
# VSCode behaves horribly with a read-only config
#    ./programs/vscode.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  config.programs.home-manager.enable = true;

  config.home.sessionPath = builtins.concatLists [
    # Add aarch64-darwin homebrew to path
    (lib.optionals (pkgs.stdenv.targetPlatform.system == "aarch64-darwin") [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ] )
  ];

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

  options.my.cursorDpi = lib.mkOption {
    description = "Cursor DPI scale";
    default = 24;
    type = lib.types.int;
  };

  options.my.vsync = lib.mkOption {
    description = "Enable compositor vsync";
    default = true;
    type = lib.types.bool;
  };

  options.my.picomBackend = lib.mkOption {
    description = "Picom backend";
    default = "glx";
    type = lib.types.str;
  };

  options.my.trayOutput = lib.mkOption {
    description = "X11 output to show systray on";
    default = "DP-4";
    type = lib.types.str;
  };

  options.my.leftMonitor = lib.mkOption {
    description = "X11 Left Monitor";
    default = "DP-2";
    type = lib.types.str;
  };

  options.my.rightMonitor = lib.mkOption {
    description = "X11 Right Monitor";
    default = "DP-4";
    type = lib.types.str;
  };

  options.my.theme = lib.mkOption {
    description = "Color theme";
    default = {
      color0 = "#1d1f21";
      color1 = "#282a2e";
      color2 = "#373b41";
      color3 = "#969896";
      color4 = "#b4b7b4";
      color5 = "#c5c8c6";
      color6 = "#e0e0e0";
      color7 = "#ffffff";
      color8 = "#cc6666";
      color9 = "#de935f";
      colorA = "#f0c674";
      colorB = "#b5bd68";
      colorC = "#8abeb7";
      colorD = "#81a2be";
      colorE = "#b294bb";
      colorF = "#a3685a";
    };
    type = lib.types.attrs;
  };
}

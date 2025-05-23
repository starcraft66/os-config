{ pkgs, lib, config, inputs, ... }:

{
  imports = [
    ./programs/alacritty.nix
    ./programs/cloud.nix
    ./programs/darkman.nix
    ./programs/darwin.nix
    ./programs/devenv.nix
    ./programs/direnv.nix
    ./programs/doom-emacs.nix
    ./programs/dunst.nix
    ./programs/easyeffects.nix
    ./programs/flameshot.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/github.nix
    ./programs/gpg.nix
    ./programs/gtk.nix
    ./programs/hyprland.nix
    ./programs/i3.nix
    ./programs/jetbrains.nix
    ./programs/kubernetes.nix
    ./programs/kitty.nix
    # ./programs/mixxx.nix
    ./programs/mullvad.nix
    ./programs/neofetch.nix
    ./programs/nextcloud-client.nix
    ./programs/obs-studio.nix
    ./programs/plex-mpv-shim.nix
    ./programs/polybar.nix
    ./programs/pywal.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    # ./programs/sway.nix
    ./programs/qt.nix
    ./programs/rofi.nix
    ./programs/tmux.nix
    ./programs/udiskie.nix
    ./programs/vim.nix
    ./programs/waybar.nix
# VSCode behaves horribly with a read-only config
#    ./programs/vscode.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];

  config.home.stateVersion = "22.05";

  config.programs.home-manager.enable = true;

  config.home.sessionPath = builtins.concatLists [
    # Add aarch64-darwin homebrew to path
    (lib.optionals (pkgs.stdenv.targetPlatform.system == "aarch64-darwin") [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ] )
    (lib.optionals (pkgs.stdenv.targetPlatform.isDarwin) [ "/usr/local/share/dotnet" "$HOME/.rd/bin" "$HOME/bin" "$HOME/.dotnet/tools" ] )
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

  options.my.wayland = lib.mkOption {
    description = "Toggle between wayland and X11-specific services";
    default = false;
    type = lib.types.bool;
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

  options.my.wiredInterface = lib.mkOption {
    description = "Wired network interface name";
    default = "eno1";
    type = lib.types.str;
  };

  options.my.wirelessInterface = lib.mkOption {
    description = "Wireless network interface name";
    default = "";
    type = lib.types.str;
  };

  options.my.theme = lib.mkOption {
    description = "Color theme";
    default = {
      color0 = "#263238";
      color1 = "#2C393F";
      color2 = "#37474F";
      color3 = "#707880";
      color4 = "#C9CCD3";
      color5 = "#CDD3DE";
      color6 = "#D5DBE5";
      color7 = "#FFFFFF";
      color8 = "#EC5F67";
      color9 = "#EA9560";
      colorA = "#FFCC00";
      colorB = "#8BD649";
      colorC = "#80CBC4";
      colorD = "#89DDFF";
      colorE = "#82AAFF";
      colorF = "#EC5F67";
    };
    type = lib.types.attrs;
  };

  options.my.isWSL = lib.mkOption {
    description = "Enable usability improvements that bridge windows services with linux when running under WSL.";
    default = false;
    type = lib.types.bool;
  };
}

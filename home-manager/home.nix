{ pkgs, lib, config, inputs, ... }:

{
  imports = [
    ./programs/alacritty.nix
    ./programs/carapace.nix
    ./programs/cloud.nix
    ./programs/darkman.nix
    ./programs/darwin.nix
    ./programs/devenv.nix
    ./programs/direnv.nix
    ./programs/doom-emacs.nix
    ./programs/dunst.nix
    ./programs/easyeffects.nix
    ./programs/flameshot.nix
    ./programs/fd.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/github.nix
    ./programs/golang.nix
    ./programs/gpg.nix
    ./programs/gtk.nix
    ./programs/hyprland.nix
    ./programs/i3.nix
    ./programs/jetbrains.nix
    ./programs/jj.nix
    ./programs/kubernetes.nix
    ./programs/kitty.nix
    # ./programs/mixxx.nix
    ./programs/mullvad.nix
    ./programs/neofetch.nix
    ./programs/nextcloud-client.nix
    ./programs/nushell.nix
    ./programs/obs-studio.nix
    ./programs/plex-mpv-shim.nix
    ./programs/polybar.nix
    ./programs/python.nix
    ./programs/pywal.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    # ./programs/sway.nix
    ./programs/qt.nix
    ./programs/rofi.nix
    ./programs/television.nix
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
    [
      "$HOME/.local/bin"
    ]
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
  
  options.my.deepBlackColors = lib.mkOption {
    description = "Use deep black colors in (enable on OLED or FALD displays)";
    default = false;
    type = lib.types.bool;
  };

  options.my.darkTheme = lib.mkOption {
    description = "Dark color theme";
    default = {
      # "Citruszest"
      color0 = "#404040";
      color1 = "#ff5454";
      color2 = "#00cc7a";
      color3 = "#ffd400";
      color4 = "#00bfff";
      color5 = "#ff90fe";
      color6 = "#48d1cc";
      color7 = "#bfbfbf";
      color8 = "#808080";
      color9 = "#ff1a75";
      colorA = "#1affa3";
      colorB = "#ffff00";
      colorC = "#33cfff";
      colorD = "#ffb2fe";
      colorE = "#00fff2";
      colorF = "#f9f9f9";
      terminalBackground = "#121212";
      terminalBackgroundDeep = "#000000";
      terminalForeground = "#bfbfbf";
      terminalCursorColor = "#666666";
      terminalCursorText = "#f9f9f9";
      terminalSelectionBackground = "#ff8c00";
      terminalSelectionForeground = "#f4f4f4";
    };
    type = lib.types.attrsOf lib.types.str;
  };
  
  options.my.lightTheme = lib.mkOption {
    description = "Light color theme";
    default = {
      # "One Double Light"
      color0 = "#454b58";
      color1 = "#f74840";
      color2 = "#25a343";
      color3 = "#cc8100";
      color4 = "#0087c1";
      color5 = "#b50da9";
      color6 = "#009ab7";
      color7 = "#ebd8d9";
      color8 = "#0e131f";
      color9 = "#ff3711";
      colorA = "#00b90e";
      colorB = "#ec9900";
      colorC = "#1065de";
      colorD = "#e500d8";
      colorE = "#00b4dd";
      colorF = "#ffffff";
      terminalBackground = "#fafafa";
      terminalForeground = "#383a43";
      terminalCursorColor = "#1a1919";
      terminalCursorText = "#dbdfe5";
      terminalSelectionBackground = "#454e5e";
      terminalSelectionForeground = "#1a1919";
    };
    type = lib.types.attrsOf lib.types.str;
  };

  options.my.isWSL = lib.mkOption {
    description = "Enable usability improvements that bridge windows services with linux when running under WSL.";
    default = false;
    type = lib.types.bool;
  };
}

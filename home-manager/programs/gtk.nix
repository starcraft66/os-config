{ config, lib, pkgs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in (lib.mkIf isLinux {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Breeze-Dark";
    };
    theme = {
      name = "Breeze-Dark";
      package = pkgs.plasma5Packages.breeze-gtk;
    };
    gtk2.extraConfig = ''
      gtk-icon-name="Breeze-Dark"
      gtk-font-name="Noto Sans,  10"
    '';
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
      "gtk-button-images" = 1;
      "gtk-decoration-layout" = "icon:minimize,maximize,close";
      "gtk-enable-animations" = 1;
      "gtk-fallback-icon-theme" = "breeze";
      "gtk-font-name" = "Noto Sans,  10";
      "gtk-icon-theme-name" = "Breeze-Dark";
      "gtk-menu-images" = 1;
      "gtk-primary-button-warps-slider" = 0;
      "gtk-theme-name" = "Breeze-Dark";
      "gtk-toolbar-style" = "GTK_TOOLBAR_BOTH_HORIZ";
      "gtk-cursor-theme-name" = "breeze_cursors";
      "gtk-cursor-theme-size" = config.my.cursorDpi;
    };
  };
  home.pointerCursor = {
    x11 = {
      enable = true;
    };
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = config.my.cursorDpi;
  };
})

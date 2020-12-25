{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "breeze-dark";
    };
    theme = {
      name = "breeze-dark";
      package = pkgs.plasma5.breeze-qt5;
    };
    gtk2.extraConfig = ''
      gtk-theme-name="breeze-dark"
      gtk-icon-name="breeze-dark"
      gtk-font-name="Noto Sans,  10"
      gtk-cursor-theme-name="breeze_cursors"
      gtk-cursor-theme-size="${toString config.my.cursorDpi}"
    '';
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
      "gtk-button-images" = 1;
      "gtk-decoration-layout" = "icon:minimize,maximize,close";
      "gtk-enable-animations" = 1;
      "gtk-fallback-icon-theme" = "breeze";
      "gtk-font-name" = "Noto Sans,  10";
      "gtk-icon-theme-name" = "breeze-dark";
      "gtk-menu-images" = 1;
      "gtk-primary-button-warps-slider" = 0;
      "gtk-theme-name" = "Breeze-Dark";
      "gtk-toolbar-style" = "GTK_TOOLBAR_BOTH_HORIZ";
      "gtk-cursor-theme-name" = "breeze_cursors";
      "gtk-cursor-theme-size" = config.my.cursorDpi;
    };
  };
  xsession.pointerCursor = {
    package = pkgs.breeze-qt5;
    name = "breeze_cursors";
    size = config.my.cursorDpi;
  };
}

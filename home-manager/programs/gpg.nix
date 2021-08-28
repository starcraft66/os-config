{ config, lib, pkgs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
lib.mkMerge [
  {
    programs.gpg = {
      enable = true;
    };

    home.packages = with pkgs; [
      pass
      pwgen
    ];
  }
  (lib.mkIf isLinux {
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableScDaemon = true;
      enableSshSupport = true;
      grabKeyboardAndMouse = true;
      pinentryFlavor = "qt";
    };
  })
]

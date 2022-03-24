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
  (lib.mkIf isDarwin {
    # https://github.com/NixOS/nixpkgs/issues/155629
    programs.gpg.scdaemonSettings = { disable-ccid = true; };
  })
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

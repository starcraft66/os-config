{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
(lib.mkIf isLinux {
  systemd.user.services.mullvad-gui = {
    Unit = {
      Description = "Mullvad VPN GUI";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mullvad-vpn}/bin/mullvad-gui";
      Restart = "on-abort";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
})

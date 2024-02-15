{ config, lib, pkgs, inputs, ... }:

let inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  imports = [inputs.hyprland.homeManagerModules.default];
} // (lib.mkIf isLinux {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };

    extraConfig = ''
      $mod = SUPER
      bind = $mod, Return, exec, ${pkgs.kitty}/bin/kitty
      bind = $mod, a, exec, ${pkgs.wofi}/bin/wofi -S run
      # The position is calculated with the scaled (and transformed) resolution
      monitor=DP-1, 3840x2160@60, 0x0, 1.50
      monitor=DP-3, 3840x2160@144, 2560x0, 1.50

      misc {
        vrr = 1
      }

      # unscale XWayland
      xwayland {
        force_zero_scaling = true
      }

      env = _JAVA_AWT_WM_NONREPARENTING,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      env = NIXOS_OZONE_WL,1

      exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1.50

      # general
      bind = $mod, q, killactive
      bind = $mod, f, fullscreen

      # move focus
      bind = $mod, j, movefocus, l
      bind = $mod, k, movefocus, d
      bind = $mod, l, movefocus, u
      bind = $mod, semicolon, movefocus, r

      # workspaces
      # binds mod + [shift +] {1..10} to [move to] ws {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in ''
            bind = $mod, ${ws}, workspace, ${toString (x + 1)}
            bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
          ''
        )
        10)}

      # will switch to a submap called resize
      bind=$mod,R,submap,resize

      # will start a submap called "resize"
      submap=resize

      # sets repeatable binds for resizing the active window
      binde=,j,resizeactive,10 0
      binde=,k,resizeactive,0 10
      binde=,l,resizeactive,0 -10
      binde=,semicolon,resizeactive,-10 0

      # use reset to go back to the global submap
      bind=,escape,submap,reset

      # will reset the submap, meaning end the current one and return to the global one
      submap=reset
      # ...
    '';
  };
})

{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ neofetch ];
  xdg.configFile."neofetch/config.conf".text = ''
    # See this wiki page for more info:
    # https://github.com/dylanaraps/neofetch/wiki/Customizing-Info
    print_info() {
        info title
        info underline
        info "OS" distro
        info "Host" model
        info "Kernel" kernel
        info "Uptime" uptime
        info "Packages" packages
        info "Shell" shell
        info "Resolution" resolution
        info "DE" de
        info "WM" wm
        info "WM Theme" wm_theme
        info "Theme" theme
        info "Icons" icons
        info "Terminal" term
        info "Terminal Font" term_font
        info "CPU" cpu
        info "GPU" gpu
        info "Memory" memory
        info "Battery" battery
        info "Font" font
        info "Song" song
        info cols
    }
    uptime_shorthand="off"
    memory_percent="on"
    package_managers="on"
    shell_path="off"
    speed_shorthand="on"
    cpu_temp="C"
    refresh_rate="on"
    battery_display="barinfo"
    thumbnail_dir="${config.xdg.cacheHome}/thumbnails/neofetch"
  '';
}

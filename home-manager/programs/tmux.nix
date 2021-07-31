{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    sensibleOnTop = false;
    enable = true;
    clock24 = true;
    historyLimit = 999999999;
    newSession = false;

    extraConfig = ''
      # rebind main key
      unbind C-b
      unbind C-a
      set -g prefix C-a
      bind C-a send-prefix

      # Binds to split the panes
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Reload the running-config
      bind r source-file ~/.config/tmux/tmux.conf

      # gimmi dat history
      set-option -g history-limit 999999999

      # Nice Yellow Status Line
      set -g status-style bg=yellow,fg=black

      # vi mouse tweaks
      set -g mouse on
      bind -T copy-mode-vi M-Up              send-keys -X scroll-up
      bind -T copy-mode-vi M-Down            send-keys -X scroll-down
      bind -T copy-mode-vi M-PageUp          send-keys -X halfpage-up
      bind -T copy-mode-vi M-PageDown        send-keys -X halfpage-down
      bind -T copy-mode-vi PageDown          send-keys -X page-down
      bind -T copy-mode-vi PageUp            send-keys -X page-up
    '';
  };
}


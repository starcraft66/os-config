{ ... }:
{
  programs.television = {
    enable = true;
    settings = {
      tick_rate = 50;
      default_channel = "files";

      # History
      history_size = 200;
      global_history = false;

      ui = {
        ui_scale = 100;
        orientation = "landscape";
        theme = "default";

        input_bar = {
          position = "top";
          prompt = ">";
          border_type = "rounded";
        };

        status_bar = {
          separator_open = "";
          separator_close = "";
          hidden = false;
        };

        results_panel = {
          border_type = "rounded";
        };

        preview_panel = {
          size = 50;
          scrollbar = true;
          border_type = "rounded";
          hidden = false;
        };

        help_panel = {
          show_categories = true;
          hidden = true;
        };

        remote_control = {
          show_channel_descriptions = true;
          sort_alphabetically = true;
          # disabled = false
        };

        # ui.theme_overrides = { ... };  # (optional overrides)
      };

      keybindings = {
        # Application control
        "esc" = "quit";
        "ctrl-c" = "quit";

        # Navigation and selection
        "down" = "select_next_entry";
        "ctrl-n" = "select_next_entry";
        "ctrl-k" = "select_next_entry";
        "up" = "select_prev_entry";
        "ctrl-p" = "select_prev_entry";
        "ctrl-l" = "select_prev_entry";

        # History navigation
        "ctrl-up" = "select_prev_history";
        "ctrl-down" = "select_next_history";

        # Multi-selection
        "tab" = "toggle_selection_down";
        "backtab" = "toggle_selection_up";
        "enter" = "confirm_selection";

        # Preview panel control
        "pagedown" = "scroll_preview_half_page_down";
        "pageup" = "scroll_preview_half_page_up";

        # Data operations
        "ctrl-y" = "copy_entry_to_clipboard";
        "ctrl-r" = "reload_source";
        "ctrl-s" = "cycle_sources";

        # UI Features
        "ctrl-t" = "toggle_remote_control";
        "ctrl-o" = "toggle_preview";
        "ctrl-h" = "toggle_help";
        "f12" = "toggle_status_bar";
        # "ctrl-l" = "toggle_layout";

        # Input field actions
        "backspace" = "delete_prev_char";
        "ctrl-w" = "delete_prev_word";
        "ctrl-u" = "delete_line";
        "delete" = "delete_next_char";
        "left" = "go_to_prev_char";
        "right" = "go_to_next_char";
        "home" = "go_to_input_start";
        "ctrl-a" = "go_to_input_start";
        "end" = "go_to_input_end";
        "ctrl-e" = "go_to_input_end";
      };

      events = {
        "mouse-scroll-up" = "scroll_preview_up";
        "mouse-scroll-down" = "scroll_preview_down";
      };

      shell_integration = {
        fallback_channel = "files";

        channel_triggers = {
          "alias" = [ "alias" "unalias" ];
          "env" = [ "export" "unset" ];
          "dirs" = [ "cd" "ls" "rmdir" ];
          "files" = [
            "cat"
            "less"
            "head"
            "tail"
            "vim"
            "nano"
            "bat"
            "cp"
            "mv"
            "rm"
            "touch"
            "chmod"
            "chown"
            "ln"
            "tar"
            "zip"
            "unzip"
            "gzip"
            "gunzip"
            "xz"
          ];
          "git-diff" = [ "git add" "git restore" ];
          "git-branch" = [
            "git checkout"
            "git branch"
            "git merge"
            "git rebase"
            "git pull"
            "git push"
          ];
          "git-log" = [ "git log" "git show" ];
          "docker-images" = [ "docker run" ];
          "git-repos" = [ "nvim" "code" "hx" "git clone" ];
        };

        keybindings = {
          smart_autocomplete = "ctrl-t";
          command_history = "ctrl-r";
        };
      };
    };
  };
}

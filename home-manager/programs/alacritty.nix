{ config, lib, pkgs, ... }:

let
  launcher = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
  fontFamily = "MesloLGS Nerd Font Mono";
in
{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    # Any items in the `env` entry below will be added as
    # environment variables. Some entries may override variables
    # set by alacritty itself.
    env = { };

    window = {
      dimensions = {
        columns = 80;
        lines = 24;
      };

      padding = {
        x = 2;
        y = 2;
      };

      decorations = "full";
      dynamic_padding = true;
      dynamic_title = true;
    };

    scrolling = {
      # Specifying '0' will disable scrolling.
      history = 10000;

      # Number of lines the viewport will move for every line scrolled when
      # scrollback is enabled (history > 0).
      multiplier = 3;
    };

    font = {
      size = config.my.terminalFontSize;

      normal.family = fontFamily;
      normal.style = "Regular";
      bold.family = fontFamily;
      bold.style = "Bold";
      italic.family = fontFamily;
      italic.style = "Italic";
      bold_italic.family = fontFamily;
      bold_italic.style = "Bold Italic";

      offset = {
        x = 0;
        y = 0;
      };

      glyph_offset = {
        x = 0;
        y = 0;
      };

      # OS X only
      use_thin_strokes = true;
    };

    # Colors (Tomorrow Night)
    colors = {
      # Default colors
      primary = {
        background = "0x1d1f21";
        foreground = "0xc5c8c6";
      };

      # Normal colors
      normal = {
        black =   "0x1d1f21";
        red =     "0xcc6666";
        green =   "0xb5bd68";
        yellow =  "0xe6c547";
        blue =    "0x81a2be";
        magenta = "0xb294bb";
        cyan =    "0x70c0ba";
        white =   "0x373b41";
      };
      # Bright colors
      bright = {
        black =   "0x666666";
        red =     "0xff3334";
        green =   "0x9ec400";
        yellow =  "0xe7c547";
        blue =    "0x81a2be";
        magenta = "0xb77ee0";
        cyan =    "0x54ced6";
        white =   "0x282a2e";
      };
    };

    bell = {
      animation = "EaseOutExpo";
      duration = 0;
    };

    background_opacity = 0.98;

    mouse_bindings = [
      { mouse = "Middle"; action = "PasteSelection"; }
    ];

    mouse = {
      hide_when_typing = false;
    };

    hints = {
      enabled = [
        {
          regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\\u0000-\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
          command = "xdg-open";
          post_processing = true;
          mouse = {
            enabled = true;
            mods = "None";
          };
          binding = {
            key = "U";
            mods = "Control|Shift";
          };
        }
      ];
    };

    selection = {
      semantic_escape_chars = ",│`|:\"' ()[]{}<>";
      save_to_clipboard = false;
    };

    cursor = {
      style = "Block";
      vi_mode_style = "Block";
      unfocused_hollow = true;
    };

    live_config_reload = true;

    # Send ESC (\\x1b) before characters when alt is pressed.
    alt_send_esc = true;

    # Since strings are quoted once by nix and then yaml, \x must become \\x
    key_bindings = [
      { key = "V";        mods = "Command"; action = "Paste";                         }
      { key = "C";        mods = "Command"; action = "Copy";                          }
      { key = "Paste";                      action = "Paste";                         }
      { key = "Copy";                       action = "Copy";                          }
      { key = "H";        mods = "Command"; action = "Hide";                          }
      { key = "Q";        mods = "Command"; action = "Quit";                          }
      { key = "W";        mods = "Command"; action = "Quit";                          }
      { key = "Home";                       chars = "\\x1bOH";   mode = "AppCursor";  }
      { key = "Home";                       chars = "\\x1b[H";   mode = "~AppCursor"; }
      { key = "End";                        chars = "\\x1bOF";   mode = "AppCursor";  }
      { key = "End";                        chars = "\\x1b[F";   mode = "~AppCursor"; }
      { key = "Key0";     mods = "Command"; action = "ResetFontSize";                 }
      { key = "Equals";   mods = "Command"; action = "IncreaseFontSize";              }
      { key = "Minus";    mods = "Command"; action = "DecreaseFontSize";              }
      { key = "K";        mods = "Command"; action = "ClearHistory";                  }
      { key = "K";        mods = "Command"; chars = "\\x0c";                          }
      { key = "L";        mods = "Control"; action = "ClearLogNotice";                }
      { key = "L";        mods = "Control"; chars = "\\x0c";                          }
      { key = "PageUp";   mods = "Shift";   chars = "\\x1b[5;2;~";                    }
      { key = "PageUp";   mods = "Control"; chars = "\\x1b[5;5;~";                    }
      { key = "PageUp";                     chars = "\\x1b[5;~";                      }
      { key = "PageDown"; mods = "Shift";   chars = "\\x1b[6;2;~";                    }
      { key = "PageDown"; mods = "Control"; chars = "\\x1b[6;5;~";                    }
      { key = "PageDown";                   chars = "\\x1b[6;~";                      }
      { key = "Tab";      mods = "Shift";   chars = "\\x1b[Z";                        }
      { key = "Back";                       chars = "\\x7f";                          }
      { key = "Back";     mods = "Alt";     chars = "\\x1b\\x7f";                     }
      { key = "Insert";                     chars = "\\x1b[2;~";                      }
      { key = "Delete";                     chars = "\\x1b[3;~";                      }
      { key = "Left";     mods = "Shift";   chars = "\\x1b[1;2D";                     }
      { key = "Left";     mods = "Control"; chars = "\\x1b[1;5D";                     }
      { key = "Left";     mods = "Alt";     chars = "\\x1b[1;3D";                     }
      { key = "Left";                       chars = "\\x1b[D";   mode = "~AppCursor"; }
      { key = "Left";                       chars = "\\x1bOD";   mode = "AppCursor";  }
      { key = "Right";    mods = "Shift";   chars = "\\x1b[1;2C";                     }
      { key = "Right";    mods = "Control"; chars = "\\x1b[1;5C";                     }
      { key = "Right";    mods = "Alt";     chars = "\\x1b[1;3C";                     }
      { key = "Right";                      chars = "\\x1b[C";   mode = "~AppCursor"; }
      { key = "Right";                      chars = "\\x1bOC";   mode = "AppCursor";  }
      { key = "Up";       mods = "Shift";   chars = "\\x1b[1;2A";                     }
      { key = "Up";       mods = "Control"; chars = "\\x1b[1;5A";                     }
      { key = "Up";       mods = "Alt";     chars = "\\x1b[1;3A";                     }
      { key = "Up";                         chars = "\\x1b[A";   mode = "~AppCursor"; }
      { key = "Up";                         chars = "\\x1bOA";   mode = "AppCursor";  }
      { key = "Down";     mods = "Shift";   chars = "\\x1b[1;2B";                     }
      { key = "Down";     mods = "Control"; chars = "\\x1b[1;5B";                     }
      { key = "Down";     mods = "Alt";     chars = "\\x1b[1;3B";                     }
      { key = "Down";                       chars = "\\x1b[B";   mode = "~AppCursor"; }
      { key = "Down";                       chars = "\\x1bOB";   mode = "AppCursor";  }
      { key = "F1";                         chars = "\\x1bOP";                        }
      { key = "F2";                         chars = "\\x1bOQ";                        }
      { key = "F3";                         chars = "\\x1bOR";                        }
      { key = "F4";                         chars = "\\x1bOS";                        }
      { key = "F5";                         chars = "\\x1b[15;~";                     }
      { key = "F6";                         chars = "\\x1b[17;~";                     }
      { key = "F7";                         chars = "\\x1b[18;~";                     }
      { key = "F8";                         chars = "\\x1b[19;~";                     }
      { key = "F9";                         chars = "\\x1b[20;~";                     }
      { key = "F10";                        chars = "\\x1b[21;~";                     }
      { key = "F11";                        chars = "\\x1b[23;~";                     }
      { key = "F12";                        chars = "\\x1b[24;~";                     }
      { key = "F1";       mods = "Shift";   chars = "\\x1b[1;2P";                     }
      { key = "F2";       mods = "Shift";   chars = "\\x1b[1;2Q";                     }
      { key = "F3";       mods = "Shift";   chars = "\\x1b[1;2R";                     }
      { key = "F4";       mods = "Shift";   chars = "\\x1b[1;2S";                     }
      { key = "F5";       mods = "Shift";   chars = "\\x1b[15;2;~";                   }
      { key = "F6";       mods = "Shift";   chars = "\\x1b[17;2;~";                   }
      { key = "F7";       mods = "Shift";   chars = "\\x1b[18;2;~";                   }
      { key = "F8";       mods = "Shift";   chars = "\\x1b[19;2;~";                   }
      { key = "F9";       mods = "Shift";   chars = "\\x1b[20;2;~";                   }
      { key = "F10";      mods = "Shift";   chars = "\\x1b[21;2;~";                   }
      { key = "F11";      mods = "Shift";   chars = "\\x1b[23;2;~";                   }
      { key = "F12";      mods = "Shift";   chars = "\\x1b[24;2;~";                   }
      { key = "F1";       mods = "Control"; chars = "\\x1b[1;5P";                     }
      { key = "F2";       mods = "Control"; chars = "\\x1b[1;5Q";                     }
      { key = "F3";       mods = "Control"; chars = "\\x1b[1;5R";                     }
      { key = "F4";       mods = "Control"; chars = "\\x1b[1;5S";                     }
      { key = "F5";       mods = "Control"; chars = "\\x1b[15;5;~";                   }
      { key = "F6";       mods = "Control"; chars = "\\x1b[17;5;~";                   }
      { key = "F7";       mods = "Control"; chars = "\\x1b[18;5;~";                   }
      { key = "F8";       mods = "Control"; chars = "\\x1b[19;5;~";                   }
      { key = "F9";       mods = "Control"; chars = "\\x1b[20;5;~";                   }
      { key = "F10";      mods = "Control"; chars = "\\x1b[21;5;~";                   }
      { key = "F11";      mods = "Control"; chars = "\\x1b[23;5;~";                   }
      { key = "F12";      mods = "Control"; chars = "\\x1b[24;5;~";                   }
      { key = "F1";       mods = "Alt";     chars = "\\x1b[1;6P";                     }
      { key = "F2";       mods = "Alt";     chars = "\\x1b[1;6Q";                     }
      { key = "F3";       mods = "Alt";     chars = "\\x1b[1;6R";                     }
      { key = "F4";       mods = "Alt";     chars = "\\x1b[1;6S";                     }
      { key = "F5";       mods = "Alt";     chars = "\\x1b[15;6;~";                   }
      { key = "F6";       mods = "Alt";     chars = "\\x1b[17;6;~";                   }
      { key = "F7";       mods = "Alt";     chars = "\\x1b[18;6;~";                   }
      { key = "F8";       mods = "Alt";     chars = "\\x1b[19;6;~";                   }
      { key = "F9";       mods = "Alt";     chars = "\\x1b[20;6;~";                   }
      { key = "F10";      mods = "Alt";     chars = "\\x1b[21;6;~";                   }
      { key = "F11";      mods = "Alt";     chars = "\\x1b[23;6;~";                   }
      { key = "F12";      mods = "Alt";     chars = "\\x1b[24;6;~";                   }
      { key = "F1";       mods = "Command"; chars = "\\x1b[1;3P";                     }
      { key = "F2";       mods = "Command"; chars = "\\x1b[1;3Q";                     }
      { key = "F3";       mods = "Command"; chars = "\\x1b[1;3R";                     }
      { key = "F4";       mods = "Command"; chars = "\\x1b[1;3S";                     }
      { key = "F5";       mods = "Command"; chars = "\\x1b[15;3;~";                   }
      { key = "F6";       mods = "Command"; chars = "\\x1b[17;3;~";                   }
      { key = "F7";       mods = "Command"; chars = "\\x1b[18;3;~";                   }
      { key = "F8";       mods = "Command"; chars = "\\x1b[19;3;~";                   }
      { key = "F9";       mods = "Command"; chars = "\\x1b[20;3;~";                   }
      { key = "F10";      mods = "Command"; chars = "\\x1b[21;3;~";                   }
      { key = "F11";      mods = "Command"; chars = "\\x1b[23;3;~";                   }
      { key = "F12";      mods = "Command"; chars = "\\x1b[24;3;~";                   }
      { key = "NumpadEnter";                chars = "\n";                             }
    ];
  };
}


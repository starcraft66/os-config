{ config, pkgs, lib, ... }:


{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    plugins = [
      # Vi keybindings
      {
        name = "zsh-vi-mode";
        file = "./share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        src = pkgs.zsh-vi-mode;
      }
    ];

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
      share = false;
      size = 100000;
      save = 100000;
    };

    sessionVariables = {
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
      EDITOR = "vi";
      ZVM_VI_ESCAPE_BINDKEY = "kl";
    };

    shellAliases = rec {
      ".."   = "cd ..";
      ls      = "${pkgs.eza}/bin/exa --color=auto --group-directories-first --classify";
      lst     = "${ls} --tree";
      la      = "${ls} --all";
      ll      = "${ls} --all --long --header --group";
      llt     = "${ll} --tree";
      tree    = "${ls} --tree";
      cdtemp  = "cd `mktemp -d`";
      cp      = "cp -iv";
      ln      = "ln -v";
      mkdir   = "mkdir -vp";
      mv      = "mv -iv";
      rm      = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.targetPlatform.isDarwin "rm -v")
        (lib.mkIf (!pkgs.stdenv.targetPlatform.isDarwin) "rm -Iv")
      ];
      dh      = "du -h";
      df      = "df -h";
      su      = "sudo -E su -m";
      sysu    = "systemctl --user";
      jnsu    = "journalctl --user";
      svim    = "sudoedit";
      zreload = "export ZSH_RELOADING_SHELL=1; source $ZDOTDIR/.zshenv; source $ZDOTDIR/.zshrc; unset ZSH_RELOADING_SHELL";
    };

    profileExtra = ''
      setopt incappendhistory
      setopt histfindnodups
      setopt histreduceblanks
      setopt histverify
      setopt correct                                                  # Auto correct mistakes
      setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
      setopt nocaseglob                                               # Case insensitive globbing
      setopt rcexpandparam                                            # Array expension with parameters
      #setopt nocheckjobs                                              # Don't warn about running processes when exiting
      setopt numericglobsort                                          # Sort filenames numerically when it makes sense
      unsetopt nobeep                                                 # Enable beep
      setopt appendhistory                                            # Immediately append history instead of overwriting
      unsetopt histignorealldups                                      # If a new command is a duplicate, do not remove the older one
      setopt interactivecomments
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' rehash true                              # automatically find new executables in path
      # Speed up completions
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      mkdir -p "$(dirname ${config.xdg.cacheHome}/zsh/completion-cache)"
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/completion-cache"
      zstyle ':completion:*' menu select
      WORDCHARS=''${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word
    ''; 

    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ""; # "do something";
      zshConfig = lib.mkOrder 1000 (''
        # Reload fzf binds after vi mode
        zvm_after_init() {
          source ${config.programs.fzf.package}/share/fzf/key-bindings.zsh
        }
        if [ -z $ZSH_RELOADING_SHELL - ]; then
        echo $USER@$HOST  $(uname -srm) \
            $(sed -n 's/^NAME=//p' /etc/os-release 2>/dev/null || printf "") \
            $(sed -n 's/^VERSION=//p' /etc/os-release 2>/dev/null || printf "")
        fi
        ## Keybindings section
        # vi movement keys on home row
        bindkey -M vicmd j vi-backward-char
        bindkey -M vicmd k vi-down-line-or-history
        bindkey -M vicmd l vi-up-line-or-history
        bindkey -M vicmd \; vi-forward-char
        bindkey -e
        bindkey '^[[7~' beginning-of-line                               # Home key
        bindkey '^[[H' beginning-of-line                                # Home key
        if [[ "''${terminfo[khome]}" != "" ]]; then
        bindkey "''${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
        fi
        bindkey '^[[8~' end-of-line                                     # End key
        bindkey '^[[F' end-of-line                                     # End key
        if [[ "''${terminfo[kend]}" != "" ]]; then
        bindkey "''${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
        fi
        bindkey '^[[2~' overwrite-mode                                  # Insert key
        bindkey '^[[3~' delete-char                                     # Delete key
        bindkey '^[[C'  forward-char                                    # Right key
        bindkey '^[[D'  backward-char                                   # Left key
        bindkey '^[[5~' history-beginning-search-backward               # Page up key
        bindkey '^[[6~' history-beginning-search-forward                # Page down key
        # Navigate words with ctrl+arrow keys
        bindkey '^[Oc' forward-word                                     #
        bindkey '^[Od' backward-word                                    #
        bindkey '^[[1;5D' backward-word                                 #
        bindkey '^[[1;5C' forward-word                                  #
        bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
        bindkey '^[[Z' undo                                             # Shift+tab undo last action
        # Theming section
        autoload -U colors
        colors

        ## VERY IMPORTANT!!!!
        unset RPS1 RPROMPT
      '' + lib.readFile ./kubectl_aliases.sh);
    in lib.mkMerge [
      zshConfigEarlyInit
      zshConfig
    ];
  };
}

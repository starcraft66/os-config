{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Tristan Gosselin-Hane";
    userEmail = "starcraft66@gmail.com";

    signing = {
      key = "9D98CDACFF04FD78";
      signByDefault = false;
    };

    extraConfig = {
      pull.ff = "only";
      push.default = "current";
      merge.tool = "vimdiff";
      mergetool.prompt = true;
      difftool.prompt = false;
      diff.tool = "vimdiff";
      advice.addEmptyPathspec = false;
      diff.colorMoved = "default";
    };
    
    aliases = rec {
      b = "branch -vv";
      d = "diff";
      s = "show";
      f = "fetch --verbose";
      u = "reset HEAD";
      bn = "checkout -b";
      ch = "checkout";
      dc = "diff --cached";
      st = "status";
      # Convenient aliases for committing
      cm = "commit --verbose";
      cma = "${cm} --amend";
      cmar = "${cma} --reuse-message=HEAD";
      # Yeah....
      cmare = "${cmar} --edit";
      # Uhhhhhhh... nice
      cmard = "${cmar} --date=format:relative:now";
      cmarde = "${cmard} --edit";
      # Pretty graph
      graph = "! git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      # Shows the latest commit with more detail
      latest = "show HEAD --summary";
      # Prints all aliases
      aliases = "! git config --get-regexp '^alias\\.' | sed -e 's/^alias\\.//' -e 's/\\ /\\ =\\ /' | grep -v '^aliases' | sort";
      # Quick view of all recents commits for stand-ups
      oneline = "log --pretty=oneline";
      activity = "! git for-each-ref --sort=-committerdate refs/heads/ "
                + "--format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
      squash-all = ''!f(){ git reset $(git commit-tree HEAD^{tree} -m "''${1:-A new start}");};f'';
    };

    # Not in 20.03, wait until 20.09
    # delta.enable = true;
    # delta.options = {
    #   line-numbers = true;
    #   side-by-side = true;
    #   whitespace-error-style = "22 reverse";
    #   syntax-theme = "ansi-dark";
    # };
  };
}
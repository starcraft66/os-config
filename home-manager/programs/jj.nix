{ pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = "Tristan Gosselin-Hane";
      user.email = "starcraft66@gmail.com";
      signing = {
        behavior = "own";
        backend = "gpg";
      };
      git = {
        sign-on-push = true;
        colocate = true;
      };
      ui.diff-formatter = ["${pkgs.difftastic}/bin/difft" "--color=always" "$left" "$right"];
    };
  };
  
  programs.jjui.enable = true;
}
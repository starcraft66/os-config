{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    package = pkgs.vscode;

    userSettings = {
      python.venvFolders =  [
        "envs"
        ".pyenv"
        ".direnv"
        "/home/tristan/.local/share/virtualenvs"
        "/Users/tristan/.local/share/virtualenvs"
      ];
      "explorer.confirmDragAndDrop" = false;
      "latex-workshop.view.pdf.viewer" = "tab";
      "workbench.colorTheme" = "Deepdark Material Theme | Full Black Version";
      "window.zoomLevel" = 0;
      "workbench.iconTheme" = "vscode-icons";
      "cSpell.enabled" = false;
      "python.jediEnabled" = false;
      "vsicons.dontShowNewVersionMessage" = true;
      "python.languageServer" = "Microsoft";
    };

    # keybindings = {

    # };

    # not managed for now
    extensions = [

    ];
  };
}


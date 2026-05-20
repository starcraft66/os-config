{ inputs, pkgs, ... }:

{
  imports = [ inputs.peon-ping.homeManagerModules.default ];

  programs.peon-ping = {
    enable = true;
    package = inputs.peon-ping.packages.${pkgs.system}.default;
    claudeCodeIntegration = true;

    settings = {
      default_pack = "sc_kerrigan";
      volume = 0.7;
      enabled = true;
      desktop_notifications = true;
      categories = {
        "session.start" = true;
        "task.complete" = true;
        "task.error" = true;
        "input.required" = true;
        "resource.limit" = true;
        "user.spam" = true;
      };
    };

    # Install packs from og-packs (simple string notation)
    # and custom sources (attrset with name + src)
    installPacks = [
      "peon"
      "glados"
      "sc_kerrigan"
      # Custom pack from GitHub (openpeon.com registry)
      # {
      #   name = "mr_meeseeks";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "kasperhendriks";
      #     repo = "openpeon-mrmeeseeks";
      #     rev = "main";  # or use a commit hash for reproducibility
      #     sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      #   };
      # }
    ];
    enableZshIntegration = true;
  };
}
{ inputs, pkgs, ... }:

{
  imports = [ inputs.peon-ping.homeManagerModules.default ];

  programs.peon-ping = {
    enable = true;
    package = inputs.peon-ping.packages.${pkgs.system}.default;
    claudeCodeIntegration = true;

    settings = {
      default_pack = "nier-2b";
      volume = 0.7;
      enabled = true;
      desktop_notifications = true;
      meeting_detect = true;
      focus_detect = true;
      categories = {
        "session.start" = false;
        "task.acknowledge" = false;
        "task.complete" = true;
        "task.error" = false;
        "input.required" = true;
        "resource.limit" = true;
        "user.spam" = false;
      };
    };

    # Install packs from og-packs (simple string notation)
    # and custom sources (attrset with name + src)
    installPacks = [
      "peon"
      "peasant"
      "murloc"
      "goblin"
      "sc_scv"
      "sc_firebat"
      "sc_medic"
      "sc_tank"
      "sc_vessel"
      "sc_terran"
      "sc_kerrigan"
      # Custom pack from GitHub (openpeon.com registry)
      {
        name = "nier-2b";
        src = pkgs.fetchFromGitHub {
          owner = "enolive";
          repo = "openpeon-pack-nier-2b";
          rev = "v1.0.1";
          sha256 = "sha256-2X6qS8ORRbvkeYehSR3VWIMoWo3HZl1+5BIlDvIJnhk=";
        };
      }
    ];
    enableZshIntegration = true;
  };
}
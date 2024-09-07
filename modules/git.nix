{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Frederik Richter";
    userEmail = "frederik.richter@mailbox.org";
    aliases = {
      st = "status";
      cm = "commit";
      co = "checkout";
      br = "branch";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
    };
    extraConfig = {
      core = {
        editor = "$EDITOR";
      };
      color = {
        ui = true;
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      url = {
          "ssh://git@github.com/" = {
              insteadOf = "https://github.com/";
          };
      };
    };
    ignores = [
    ];
  };
}

{ config, pkgs, ... }:
{
  home.packages = [ pkgs.git-credential-manager ];

  programs.git = {
    enable = true;
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id.pub";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Frederik Richter";
        email = "frederik.richter@mailbox.org";
      };
      alias = {
        st = "status";
        cm = "commit";
        co = "checkout";
        br = "branch";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
      };
      gpg.format = "ssh";
      color.ui = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      credential = {
        helper = "manager";
        credentialStore = "cache";
        provider = "generic";
        "https://git.rz.tu-bs.de" = {
          username = "frederik.richter@tu-braunschweig.de";
          provider = "generic";
        };
      };
    };
  };
}


{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        git
        git-credential-manager
    ];
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
            credential = {
                helper = "manager";
                "https://git.rz.tu-bs.de/".username = "frederik.richer@tu-braunschweig.de";
                credentialStore = "cache";
            };
        };
    };
}

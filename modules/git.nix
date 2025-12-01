{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        git
        git-credential-manager
    ];
    programs.git = {
        enable = true;
        settings = {
            user = {
                user = "Frederik Richter";
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
                "https://git.rz.tu-bs.de".provider = "generic";
                credentialStore = "cache";
                provide = "generic";
            };
        };
    };
}

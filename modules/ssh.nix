{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        matchBlocks = {
            "github.com" = {
                hostname = "github.com";
                user = "git";
                identityFile = "~/.ssh/id";
                extraOptions = {
                    identitiesOnly = "yes";
                };
            };
            "gitlab_ibr" = {
                hostname = "gitlab.ibr.cs.tu-bs.de";
                user = "git";
                identityFile = "~/.ssh/id_tu";
                extraOptions = {
                    identitiesOnly = "yes";
                };
            };

            "*" = {
                addKeysToAgent = "yes";
                forwardAgent = true;
            };
        };
    };
    services.ssh-agent = {
        enable = true;
    };
}

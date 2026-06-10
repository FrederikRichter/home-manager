{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = {
            "gitlab_ibr" = {
                hostname = "gitlab.ibr.cs.tu-bs.de";
                user = "git";
                identityFile = "~/.ssh/id_tu";
                extraOptions = {
                    identitiesOnly = "yes";
                };
            };
            "*" = {
                identityFile = "~/.ssh/id";
                extraOptions = {
                    identitiesOnly = "yes";
                };
                forwardAgent = true;
            };
        };
    };
    services.ssh-agent = {
        enable = true;
    };
}

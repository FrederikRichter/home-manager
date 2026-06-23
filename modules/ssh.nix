{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = {
            "gitlab_ibr" = {
                hostname = "gitlab.ibr.cs.tu-bs.de";
                port = 222;
                user = "git";
                identityFile = "~/.ssh/id_tu";
                extraOptions = {
                    IdentitiesOnly = "yes";
                };
            };
            "*" = {
                identityFile = "~/.ssh/id";
                extraOptions = {
                    IdentitiesOnly = "yes";
                };
                forwardAgent = true;
            };
        };
    };
    services.ssh-agent = {
        enable = true;
    };
}

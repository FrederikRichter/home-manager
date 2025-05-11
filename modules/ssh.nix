{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        forwardAgent = true;
        serverAliveInterval = 60;
        addKeysToAgent = "yes";
        matchBlocks = {
            "gitlab-tu-cs" = {
                hostname = "git.cg.cs.tu-bs.de";
                user = "gogs";
                identityFile = "~/.ssh/id_rsa";
                extraOptions = {
                    identitiesOnly = "yes";
                };
            };
            "github.com" = {
                hostname = "github.com";
                user = "git";
                identityFile = "~/.ssh/id_rsa";
                extraOptions = {
                    identitiesOnly = "yes";
                };
            };
        };
        extraConfig = ''
            '';
    };
    services.ssh-agent = {
        enable = true;
    };
}

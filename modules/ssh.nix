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

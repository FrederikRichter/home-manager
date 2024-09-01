{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        compression = true;
        forwardAgent = true;
        serverAliveInterval = 60;
        addKeysToAgent = "yes";
        matchBlocks = {
            "github.com" = {
                hostname = "github.com";
                user = "git";
                identityFile = "~/.ssh/id_rsa";
                extraOptions = {
                    PreferredAuthentications = "publickey";
                    IdentitiesOnly = "yes";
                };
            };
        };
    };
    services.ssh-agent = {
        enable = true;
    };
}

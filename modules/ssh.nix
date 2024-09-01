{ config, pkgs, libs, ... }:
{
    # copy ssh keys into the right directory
    home.file = {
        ".ssh/id_rsa".source = ../secrets/ssh/id_rsa;
        ".ssh/id_rsa.pub".source = ../secrets/ssh/id_rsa.pub;
    };

    programs.ssh = {
        enable = true;
        compression = true;
        forwardAgent = true;
        serverAliveInterval = 60;
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

{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        compression = true;
        forwardAgent = true;
        serverAliveInterval = 60;
        addKeysToAgent = "yes";
        matchBlocks = {
            "eu.nixbuild.net" = {
                hostname = "eu.nixbuild.net";
                identityFile = "~/.ssh/nixbuild";
                extraOptions = {
                    PubkeyAcceptedKeyTypes = "ssh-ed25519";
                    ServerAliveInterval = "60";
                    IPQoS = "throughput";
                };
            };

            "github.com" = {
                hostname = "github.com";
                user = "git";
                identityFile = "~/.ssh/id_rsa";
                extraOptions = {
#                    PreferredAuthentifications = "publickey";
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

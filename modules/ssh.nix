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
#                    PreferredAuthentifications = "publickey";
                    identitiesOnly = "yes";
                };
            };
            "nix-server" = {
                hostname = "192.168.1.189";
                user = "frederik";
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

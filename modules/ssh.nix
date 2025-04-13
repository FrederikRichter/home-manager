{ config, pkgs, libs, ... }:
{
    programs.ssh = {
        enable = true;
        compression = true;
        forwardAgent = true;
        serverAliveInterval = 60;
        addKeysToAgent = "yes";
        matchBlocks = {
            "gitlab-tu" = {
                hostname = "git.rz.tu-bs.de";
                user = "git";
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
            "nix-server" = {
                hostname = "192.168.1.189";
                user = "frederik";
                identityFile = "~/.ssh/id_rsa";
                extraOptions = {
                    identitiesOnly = "yes";
                };
            };
            "nix-remote-builder" = {
                hostname = "192.168.1.189";
                user = "nixremote";
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

_:
let
  mkTuHost = hostName: extra: {
    HostName = hostName;
    User = "git";
    IdentityFile = "~/.ssh/id_tu";
  } // extra;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/id";
        IdentitiesOnly = "yes";
        ForwardAgent = "yes";
      };

      "gitlab_ibr gitlab.ibr.cs.tu-bs.de" = mkTuHost "gitlab.ibr.cs.tu-bs.de" {
        Port = 222;
      };

      "gitlab_rz git.rz.tu-bs.de" = mkTuHost "git.rz.tu-bs.de" { };
    };
  };

  services.ssh-agent.enable = true;
}


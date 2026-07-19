{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; 

    settings."*" = {
      AddKeysToAgent = "yes";
      IdentityFile = "~/.ssh/id";
      IdentitiesOnly = "yes";
      ForwardAgent = "yes";
    };

    settings.gitlab_ibr = {
      HostName = "gitlab.ibr.cs.tu-bs.de";
      Port = 222;
      User = "git";
      IdentityFile = "~/.ssh/id_tu";
      IdentitiesOnly = "yes";
      ForwardAgent = "yes";
      AddKeysToAgent = "yes";
    };

    settings.gitlab_rz = {
      HostName = "git.rz.tu-bs.de";
      User = "git";
      IdentityFile = "~/.ssh/id_tu";
      IdentitiesOnly = "yes";
      ForwardAgent = "yes";
      AddKeysToAgent = "yes";
    };
  };

  services.ssh-agent = {
    enable = true;
  };
}

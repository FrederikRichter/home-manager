{ config, pkgs, ... }:
{
    home.packages = [pkgs.git-credential-manager];
    programs.git = {
        enable = true;
        signing = {
            key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5Zsj1il8uii6uRuvAFjthAW0u1H6UKOPOgm3Rxh0SA7VhmQeKDRZpPH3S+zFT1LQK4rKuTZLXItAGdO2a5VeXI8Y44kGTOJ1klmTCoxzFLn658TH/b351l42Odhhw08XrVSTbeWRivfatRdPxLdZiLktvI7V4JvjciOuVtMW8XF41YLWq4Y/03251ePtNq0bDSYRDXNvlFMRQgpri/8rWyy2XV5mFNuyUP2c/FNae64CTRzKPvHV1ujQuNt3GniozRFfqlg9RRs+x9pIvNMeBLOqlPF43PU8z92/ylJYWJBgQr9IeeWg3sXbwAMMYyYaqu4lWh78wisBW1VoW0z7HFRAWXFe0aWJmHISuS1Ll1EreIg9PyG4K+gGfyUSrMTrVdBByXymA0xTQ0/ojmMFnapHSIut1F5H0O+tQnuL+ZdlTI9Oadi9yG18STP+xlBuxzcGjfXuTGlWQ7sqFQlTWSuenHJfdUO3YNwugJetOpVk0r8w5luQc4/kin1gg5gVRdVk9F3s9BqijCXcFHFLOiI7Cp17hs5eOHWUxlT+KY7+QcWHfzQsAfUF8AZ7IlI0h2nTP660OhFgeGBh3sQdNbfyUo/q6ODEVk5V8OOm9z4WWFIHoKChnv+dPtoGZureLR9JJNG3iqW/FBypSAYnaNvxwabl391f0h37T1Plp6Q== frederik.richter@mailbox.org";
            signByDefault = true;
        };

        settings = {
            user = {
                name = "Frederik Richter";
                email = "frederik.richter@mailbox.org";
            };
            alias = {
                st = "status";
                cm = "commit";
                co = "checkout";
                br = "branch";
                unstage = "reset HEAD --";
                last = "log -1 HEAD";
            };
            gpg = {
                format = "ssh";
            };
            core = {
                editor = "$EDITOR";
            };
            color = {
                ui = true;
            };
            pull = {
                rebase = true;
            };
            init = {
                defaultBranch = "main";
            };
            url = {
                "ssh://git@github.com/" = {
                    insteadOf = "https://github.com/";
                };
            };
            credential = {
                helper = "manager";
                "https://git.rz.tu-bs.de/".username = "frederik.richer@tu-braunschweig.de";
                "https://git.rz.tu-bs.de".provider = "generic";
                credentialStore = "cache";
                provide = "generic";
            };
        };
    };
}

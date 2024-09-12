{
    lib,
    config,
    ...
}:
{
    services.kanshi = {
        enable = true;
        settings = [
        {
            profile.name = "undocked";
            profile.outputs = [
            {
                criteria = "eDP-1";
                status = "enable";
            }
            ];
        }
        {
            profile.name = "docked";
            profile.outputs = [
            {
                criteria = "eDP-1";
                status = "disable";
            }
            {
                criteria = "DP-4";
                status = "enable";
                mode = "2560x1440@143.973Hz";
                position = "0,0";
            }
            ];
        }
        ];
    };
}

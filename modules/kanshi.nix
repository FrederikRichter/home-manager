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
                criteria = "HDMI-A-1";
                status = "enable";
                mode = "2560x1440@60Hz";
                position = "0,0";
                scale = 1.5;
            }
            ];
        }
        ];
    };
}

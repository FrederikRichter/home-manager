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
                criteria = "LG Electronics LG ULTRAGEAR 308MATW9JR37";
                status = "enable";
                mode = "2560x1440@143.973Hz";
                position = "0,0";
            }
            ];
        }
        ];
    };
}

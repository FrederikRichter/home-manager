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
            profile.name = "docked";
            profile.outputs = [
            {
                criteria = "eDP-1";
                status = "disable";
            }
            {
                criteria = "Xiaomi Corporation Mi Monitor 5744900021637";
                status = "enable";
                mode = "2560x1440@143.981Hz";
                position = "0,0";
            }
            ];
        }
        ];
    };
}

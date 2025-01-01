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
                criteria = "XMI Mi Monitor 5744900021637";
                status = "enable";
                mode = "2560x1440@99.946Hz";
                position = "0,0";
            }
            ];
        }
        ];
    };
}

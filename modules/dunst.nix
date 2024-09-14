{config, lib, ...}:
{
    services.dunst = {
        enable = true;
        settings = lib.mkDefault {
            global = {
                frame_width = 1;
            };
            urgency_low = {
                frame_color = "#000000";
            };
            urgency_normal = {
                frame_color = "#000000";
            };
            urgency_critical = {
                frame_color = "#000000";
            };
        };
    };
}

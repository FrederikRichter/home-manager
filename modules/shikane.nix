{
    config,
    lib,
    pkgs,
    ...
}:
{
    services.shikane = {
        enable = true;
        settings = {
            profile = [
            {
                name = "external-monitor-default";
                output = [
                {
                    match = "eDP-1";
                    enable = true;
                }
                {
                    match = "HDMI-A-1";
                    enable = true;
                    position = {
                        x = 0;
                        y = 0;
                    };
                    mode = "1920x1080@60Hz";
                }
                ];
            }
            {
                name = "docked Xiaomi";
                output = [
                {
                    match = "eDP-1";
                    enable = false;
                }
                {
                    match = "DP-4";
                    enable = true;
                    position = {
                        x = 0;
                        y = 0;
                    };
                    mode = "2560x1440@144Hz";
                }
                ];
            }
            {
                name = "builtin-monitor-only";
                output = [
                {
                    match = "eDP-1";
                    enable = true;
                }
                ];
            }
            ];
        };
    };
}

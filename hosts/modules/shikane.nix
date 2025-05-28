{
    config,
    lib,
    pkgs,
    ...
}:
{

    options.services.shikane.enable = lib.mkEnableOption; 

    config = lib.mkIf config.services.shikane.enable {
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
                    match = "DP-3";
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

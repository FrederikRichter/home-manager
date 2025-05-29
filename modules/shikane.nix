{config, lib, pkgs, ...}:
{

    options = {
        shikane.enable = lib.mkEnableOption "Enable shikane";
    }; 
    config = lib.mkIf config.shikane.enable {
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
                    name = "Docked Xiaomi";
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
                {
                    name = "Xiaomi only";
                    output = [
                    {
                        match = "DP-4";
                        enable = true;
                        mode = "2560x1440@180Hz";
                        adaptive_sync = true;
                        #exec = ["${pkgs.sway}/bin/swaymsg output DP-4 render_bit_depth 10"];
                    }
                    ];
                }
                ];
            };
        };
    };
}

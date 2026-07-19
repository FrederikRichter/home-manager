{config, inputs, lib, ...}:
{
    imports = [
        inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
        enable = true;
        settings = {
            bar.widgets = {
                concave_edge_corners = false;
                end = [
                    "sysmon"
                    "notifications"
                    "clipboard"
                    "volume"
                    "battery"
                    "network"
                    "bluetooth"
                    "date"
                    "tray"
                    "control-center"
                ];
                margin_ends = 10;
                margin_edge = 10;
                position = "bottom";
                scale = 1.1500000096857548;
            };

            dock = {
                background_opacity = 1.0;
            };

            notification = {
                background_opacity = 1.0;
            };

            osd = {
                background_opacity = 1.0;
            };

            shell = {
                font_family = lib.mkForce "Inter Display SemiBold";
                ui_scale = 1.1000000089406967;
            };

            theme = {
                community_palette = "GruvboxAlt";
                custom_palette = "stylix";
                mode = "light";
                wallpaper_scheme = "m3-content";
            };

            widget = {
                control-center = {
                    custom_image = ../assets/icons/nixos.svg;
                    custom_image_colorize = true;
                    glyph = "";
                };

                sysmon = {
                    display = "text";
                    highlight_color = "primary";
                };

                tray = {
                    drawer = true;
                };

                volume = {
                    mute_color = "primary";
                };
            };
        };
    };
}


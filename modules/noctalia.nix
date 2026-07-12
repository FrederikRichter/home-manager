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

            lockscreen_widgets = {
                enabled = false;
                schema_version = 2;
                widget_order = [ "lockscreen-login-box@eDP-1" ];

                grid = {
                    cell_size = 16;
                    major_interval = 4;
                    visible = true;
                };

                widget = {
                    "lockscreen-login-box@eDP-1" = {
                        box_height = 70.0;
                        box_width = 400.0;
                        cx = 720.0;
                        cy = 781.0;
                        output = "eDP-1";
                        rotation = 0.0;
                        type = "login_box";

                        settings = {
                            background_color = "surface_variant";
                            background_opacity = 0.88;
                            background_radius = 12.0;
                            input_opacity = 1.0;
                            input_radius = 6.0;
                            show_caps_lock = true;
                            show_keyboard_layout = true;
                            show_login_button = true;
                            show_password_hint = true;
                        };
                    };
                };
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

            wallpaper.default = {
                path = "/nix/store/f77sb9m7nbnbz54fai2pi4838py3jfqx-abstract.jpg";
            };

            widget = {
                control-center = {
                    custom_image = "/nix/store/nmqq9diyprmf00c5z81lcxwzdnnq00am-noctalia-5.0.0/share/noctalia/assets/images/distros/nixos.svg";
                    custom_image_colorize = true;
                    glyph = "";
                };

                sysmon = {
                    display = "text";
                    highlight_color = "primary";
                };

                volume = {
                    mute_color = "primary";
                };
            };
        };
    };
}


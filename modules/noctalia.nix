{config, inputs, lib, pkgs, ...}:
{
    home.packages = with pkgs; [
        noctalia
    ];

xdg.configFile."noctalia/config.toml".text = ''
[bar.widgets]
concave_edge_corners = false
end = [
    "sysmon",
    "notifications",
    "clipboard",
    "volume",
    "battery",
    "network",
    "bluetooth",
    "date",
    "tray",
    "control-center"
]
margin_edge = 10
margin_ends = 10
position = "bottom"
scale = 1.15

[dock]
background_opacity = 1.0

[location]
auto_locate = true

[notification]
background_opacity = 1.0

[osd]
background_opacity = 1.0

[shell]
font_family = "Inter Display SemiBold"
ui_scale = 1.1

[theme]
builtin = "Catppuccin"
mode = "dark"
source = "builtin"
wallpaper_scheme = "m3-content"

[wallpaper.default]
path = "${../assets/wallpaper/abstract.jpg}"

[widget.control-center]
custom_image = "${../assets/icons/nixos.svg}"
custom_image_colorize = true
glyph = ""

[widget.sysmon]
highlight_color = "primary"
show_value = true
visualization = "none"

[widget.tray]
drawer = true

[widget.volume]
mute_color = "primary"
'';
}


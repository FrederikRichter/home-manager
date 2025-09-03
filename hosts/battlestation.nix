{config, pkgs, lib, ...}:
{
shikane.enable = true;


hyprland.enable = true;

programs.waybar = {
    systemd.target = "hyprland-session.target";
    settings.mainBar = {
        modules-left = [ "hyprland/workspaces" "idle_inhibitor" ];
        modules-right = ["pulseaudio" "network" "battery" "cpu" "memory" "disk" "clock" "bluetooth" "tray"];
    };
};

wayland.windowManager.hyprland = {
    settings = {
        input.kb_layout = "us";
        monitor = [
            "DP-4,preferred,auto,1,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.3, sdrsaturation, 1.15"
        ];
        experimental = {
            xx_color_management_v4 = true;
        };

# Environment variables
        env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        ];

    };
};

stylix.image = ../wallpaper/mojave.jpg;

home.packages = with pkgs ;[
    r2modman
    qbittorrent
    brave
    rustdesk
    xournalpp
];

home.sessionVariables = {
    ENABLE_HDR_WSI=1;
};
}

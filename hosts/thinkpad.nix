{
    config,
    lib,
    pkgs,
    ...
}:
{	
    shikane.enable = true;
    sway.enable = true;
    swaylock.enable = true;
    hyprland.enable = true;
    
    programs.waybar = {
        systemd.target = "hyprland-session.target";
        settings.mainBar = {
            modules-left = [ "hyprland/workspaces" "idle_inhibitor" ];
            modules-right = ["pulseaudio" "network" "battery" "cpu" "memory" "disk" "clock" "tray"];
        };
    };
    wayland.windowManager.hyprland.settings.input.kb_layout = "de";

    stylix.image = ../wallpaper/akira.jpg;
}

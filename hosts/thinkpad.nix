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

    targets.genericLinux.enable = lib.mkForce false;

    
    programs.waybar = {
        systemd.targets = [ "hyprland-session.target" ];
        settings.mainBar = {
            modules-left = [ "hyprland/workspaces" "idle_inhibitor" ];
            modules-right = ["pulseaudio" "network" "battery" "cpu" "temperature" "memory" "disk" "clock" "tray"];
        };
    };
    wayland.windowManager.hyprland.settings.input.kb_layout = "us";

    stylix.image = ../assets/wallpaper/akira.jpg;
}

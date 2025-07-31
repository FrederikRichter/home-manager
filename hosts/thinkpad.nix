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
    
    programs.waybar = {
        systemd.target = "sway-session.target";
        settings.mainBar = {
            modules-left = [ "sway/workspaces" "idle_inhibitor" ];
            modules-right = ["pulseaudio" "network" "battery" "cpu" "memory" "disk" "clock" "tray"];
        };
    };
}

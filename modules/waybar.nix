{
    lib,
    config,
    pkgs,
        ...
}:
{


    programs.waybar = {
        systemd = {
            enable = true;
            target = "sway-session.target";
        };
        enable = true;
        settings.mainBar = {
            position = "bottom";
            spacing = 4;
            modules-left = [ "sway/workspaces" "idle_inhibitor" ];
            modules-center = [];
            modules-right = ["pulseaudio" "network" "battery" "cpu" "memory" "disk" "clock" "bluetooth" "tray"];
            "sway/workspaces" = {
                disable-scroll = true;
                format = "{icon}";
                format-icons = {
                    "1" = "a";
                    "2" = "s";
                    "3" = "d";
                    "4" = "f";
                };
            };

            "network" = {
                format-wifi =  "{essid} ({signalStrength}%)";
                format-ethernet =  "{ifname}";
                format-disconnected =  "offline";
            };

            "pulseaudio" = {
                format-muted = "muted ";
                format = "VOL {volume}% ";
            };

            "battery" = {
                format = "BAT discharging ({capacity}%) ";
                format-charging = "BAT charging ({capacity}%) ";
            };

            "cpu" = {
                format = "CPU {usage}% ";
            };

            "memory" = {
                format = "RAM {used}G ";
            };
            
            "disk" = {
                interval = 30;
                format = "{percentage_used}% ({path})";
            };
            
            "clock" = {
                format = "{:%H:%M %d.%m.%y}";
            };

            "idle_inhibitor" = {
                format = "{icon}";
                format-icons = {
                    activated = " O.O ";
                    deactivated = " -.- ";
                };
            };
            "bluetooth" = {
                format= " {status}";
                format-connected= " {device_alias}";
                format-connected-battery = " {device_alias} {device_battery_percentage}%";
                on-click= "exec ${pkgs.blueman}/bin/blueman-manager";
            };
        };
};
}

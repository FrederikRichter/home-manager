{config, pkgs, lib, ...}:
{
shikane.enable = true;

targets.genericLinux.enable = lib.mkForce false;

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
            ", highres,auto,2,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.5, sdrsaturation, 1.2"
            # ", highres,auto,1,bitdepth,10,vrr,1"
        ];
        # gesture = ["3, horizontal, workspace"];
    };
};


# MPV
programs.mpv.config = {
    vo="gpu-next";
    hwdec="vulkan";
    gpu-api="vulkan";
    gpu-context="waylandvk";
    profile="high-quality";
};

home.packages = with pkgs ;[
    r2modman
    qbittorrent
    rustdesk
    xournalpp
];

home.sessionVariables = {
    ENABLE_HDR_WSI=1;
};

home.stateVersion = "25.11";
}

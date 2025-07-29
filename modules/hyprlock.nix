{pkgs, config, lib, ...}:
{
options = {
        hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
    }; 
    config = lib.mkIf config.hyprlock.enable {
        programs.hyprlock.enable = true;
    };
}

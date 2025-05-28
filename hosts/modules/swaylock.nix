{config, lib, ...}:
{
options.programs.swaylock.enable = lib.mkEnableOption;

config = lib.mkIf config.options.programs.swaylock.enable {
    show-failed-attempts = true;
};
}

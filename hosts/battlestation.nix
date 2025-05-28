{config, pkgs, lib, ...}:
{
wayland.windowManager.sway.extraOptions = [
"--unsupported-gpu"
];
}

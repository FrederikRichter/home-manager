{ config, lib, ... }:
{
    services.mpris-proxy.enable = true;
    services.blueman-applet.enable = false;
}

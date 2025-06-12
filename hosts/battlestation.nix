{config, pkgs, lib, ...}:
{
shikane.enable = true;
home.packages = with pkgs ;[
r2modman
qbittorrent
];
}

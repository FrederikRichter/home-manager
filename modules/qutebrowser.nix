{ config, pkgs, ... }:
{
    programs.qutebrowser = {
        enable = true;
        keyBindings = {
            normal = {
                "m" = "spawn mpv {url}";
                # "Shift+o"
#",p" = "spawn --userscript qute-pass";
            };
        };
        searchEngines = {
                w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
                DEFAULT = "https://www.google.com/search?hl=en&q={}";
                hm = "https://home-manager-options.extranix.com/?query={}&release=release-24.05";
                np = "https://search.nixos.org/packages?channel=24.05&from=0&size=50&sort=relevance&type=packages&query={}";
                pp = "https://www.perplexity.ai/search/?q={}";
        };
    };
}

{ config, pkgs, lib, ... }:
{
    home.packages = [ pkgs.python312Packages.pynacl ];
    programs.qutebrowser = {
        enable = false;
        keyBindings = {
            normal = {
            };
        };
        searchEngines = {
                w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
                DEFAULT = "https://search.hbubli.cc/search?q={}";
                hm = "https://home-manager-options.extranix.com/?query={}&release=master";
                np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
                pp = "https://www.perplexity.ai/search/?q={}";
                yt = "https://www.youtube.com/results?search_query={}";
        };
        settings = {
            tabs.show = "never";
            url.start_pages = "https://udm14.com/";
            };
        extraConfig = ''
            config.unbind("H", mode="normal")
            config.unbind("J", mode="normal")
            config.unbind("L", mode="normal")
            config.unbind("K", mode="normal")

             # todo config.unbind("m", mode="normal")

            config.bind("m", "spawn mpv {url}", mode="normal")
            config.bind("H", "tab-prev", mode="normal")
            config.bind("L", "tab-next", mode="normal")
            config.bind("J", "back", mode="normal")
            config.bind("K", "forward", mode="normal")

            # todo config.bind("m", "forward", mode="normal")

            config.bind('pw', 'spawn --userscript qute-keepassxc --insecure', mode='normal')
        '';
    };
}

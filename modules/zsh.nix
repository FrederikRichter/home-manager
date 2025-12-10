{ config, pkgs, ... }:

{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ll = "ls -l";
			sudo = "sudo --preserve-env=PATH env";
            v = "nvim";
			hm-rollback = "bash $(home-manager generations | fzf | awk -F '-> ' '{print $2 \"/activate\"}')";
			hm = "home-manager";
            rm = "echo Use forcerm, consider using trash";
            forcerm = "rm";
            trash = "${pkgs.gtrash}/bin/gtrash";
		};
		history = {
			size = 10000;
			path = "${config.xdg.dataHome}/zsh/history";
		};
		oh-my-zsh = {
			enable = true;
			plugins = [ "git" ];
			theme = "eastwood";
		};
	};
}

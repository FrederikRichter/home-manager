{ config, pkgs, ... }:

{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ll = "ls -l";
			update = "home-manager switch --impure --show-trace";
			sudo="sudo --preserve-env=PATH env";
			tf="fuck";
			hm-rollback="bash $(home-manager generations | fzf | awk -F '-> ' '{print $2 \"/activate\"}')";
			hm="home-manager";
		};
		history = {
			size = 10000;
			path = "${config.xdg.dataHome}/zsh/history";
		};
		oh-my-zsh = {
			enable = true;
			plugins = [ "git" "thefuck" ];
			theme = "eastwood";
		};
	};
}

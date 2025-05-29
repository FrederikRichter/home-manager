{ config, pkgs, ... }:

{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ll = "ls -l";
			update = "home-manager switch --impure --flake 'github:FrederikRichter/home-manager' --show-trace";
			sudo="sudo --preserve-env=PATH env";
			tf="fuck";
            v="nvim";
			hm-rollback="bash $(home-manager generations | fzf | awk -F '-> ' '{print $2 \"/activate\"}')";
			hm="home-manager";
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

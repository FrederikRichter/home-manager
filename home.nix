{config, pkgs, inputs, ... }:
let	
	# create nix file loader function
	modulesDir = ./modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));

	mkgl = import ./scripts/mkgl.nix pkgs;

    username = builtins.getEnv "USER";

    inherit inputs;
in
{
	# Setup home constants
	home.username = "${username}";
	home.homeDirectory = "/home/${username}";

	home.stateVersion = "24.05";

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	targets.genericLinux.enable = true;

	# load all nix files from ./modules
	imports = map (f: modulesDir + "/${f}") moduleFiles ++ [ inputs.stylix.homeManagerModules.stylix ];

	# define home packages
	home.packages = with pkgs; [
	# cli
		neofetch
		htop
		yt-dlp
		powertop
		thefuck
        nixvim
        hugo
        docker
# dev/libs
        dconf
        texlive.combined.scheme-full
        gdb
		unzip
		ripgrep
		gcc
		wget
		gnupg
		gnumake
		coreutils
		ffmpeg-full
		cmake
		nixgl.auto.nixGLDefault
        swaylock
        swayidle
        wl-clipboard
        wofi
        slurp
        vesktop
        pulseaudio
	# python
		python312
	# append gl dependent programs
		] ++  [ #map (mkgl)
		firefox
		tdesktop
		inkscape
        keepassxc
        signal-desktop
        discord
        pavucontrol
        mpv
       	megacmd
		];
	
	# direct file access
	home.file = {
	};
	
	# set session vars
	home.sessionVariables = {
        EDITOR="nvim";
        SHELL="zsh";
	};
}


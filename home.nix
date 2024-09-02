{config, pkgs, inputs, ... }:
let	
	# create nix file loader function
	modulesDir = ./modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));

	mkgl = import ./scripts/mkgl.nix pkgs;
in
{
	# Setup home constants
	home.username = "hm-testing";
	home.homeDirectory = "/home/hm-testing";

	home.stateVersion = "24.05";

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	targets.genericLinux.enable = true;

	# load all nix files from ./modules
	imports = map (f: modulesDir + "/${f}") moduleFiles;

	# define home packages
	home.packages = with pkgs; [
	# cli
		neofetch
		htop
		yt-dlp
		powertop
		thefuck
        nixvim
	# dev/libs
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
	# python
		python3
	# append gl dependent programs
		] ++ map (mkgl) [
		sway
		kitty
		qutebrowser
		firefox
		tdesktop
		inkscape
		];
	
	# direct file access
	home.file = {
	};
	
	# set session vars
	home.sessionVariables = {
		# not needed because set in nixvim i suppose EDITOR = "nvim";
	};
}


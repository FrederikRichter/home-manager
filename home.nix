{config, pkgs, inputs, username, ... }:
let	
	# create nix file loader function
	modulesDir = ./modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));
	stylixTheme = config.lib.stylix.nixvim.config;
	nixvim = inputs.nixvim.packages.${pkgs.system}.default.extend stylixTheme;

	inherit pkgs;
	inherit inputs;
	inherit username;
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
	imports = map (f: modulesDir + "/${f}") moduleFiles;

	# define home packages
	home.packages = with pkgs; [
	nixvim
	# cli
        btop
        neofetch
	htop
	yt-dlp
	powertop
	typst
	thefuck
	hugo
	wakeonlan
# dev/libs
	udiskie
	usbutils
	libnotify
	bash
	dconf
	i2p
	fzf
	gdb
	unzip
	ntfs3g
	dosfstools
	ripgrep
	gcc
	wget
	gnupg
	gnumake
	coreutils
	ffmpeg-full
	libsecret
	cmake
	swaylock
	swayidle
	wl-clipboard
	wofi
	slurp
	vesktop
	pulseaudio
	grim
	cbonsai
	tor
# python
	python312Full
# append gl dependent programs
	] ++  [ #map (mkgl)
	firefox
	xournalpp
	libreoffice-qt6-fresh
	tdesktop
	inkscape
	signal-desktop
	discord
	pavucontrol
	mpv
	spotify
	simplex-chat-desktop
	zathura
	transmission_4
	] ++ [
	];
	
	# direct file access
	home.file = {
	};
	
	# set session vars
	home.sessionVariables = {
        EDITOR="nvim";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
        NIXPKGS_ALLOW_UNFREE = 1;
	};
}

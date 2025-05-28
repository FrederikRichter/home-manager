{config, pkgs, inputs, username, ... }:
let	
	# create nix file loader function
	modulesDir = ./modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));
	stylixNixvim = config.lib.stylix.nixvim.config;
	nixvim = inputs.nixvim.packages.${pkgs.system}.default.extend stylixNixvim;

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
    tree
	htop
	yt-dlp
	powertop
	typst
	hugo
	wakeonlan
# dev/libs
	udiskie
	usbutils
	libnotify
	bash
	dconf
	fzf
	gdb
	unzip
	ntfs3g
	dosfstools
	ripgrep
	wget
	coreutils
	ffmpeg-full
	libsecret
	swayidle
	wl-clipboard
	wofi
	slurp
	grim
# python
	python312Full
	xournalpp
	libreoffice-qt6-fresh
	tdesktop
	signal-desktop
	pavucontrol
    mpv
	spotify
	zathura
	transmission_4
	];

	# set session vars
	home.sessionVariables = {
        EDITOR="nvim";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
        NIXPKGS_ALLOW_UNFREE = 1;
        WLR_RENDERER="vulkan";
	};
}

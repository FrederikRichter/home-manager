{config, pkgs, inputs, username, ... }:
let	
	# create nix file loader function
	modulesDir = ../modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));
	stylixNixvim = config.lib.stylix.nixvim.config; nixvim = inputs.nixvim.packages.${pkgs.system}.default.extend stylixNixvim;
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
    android-tools
	bash
	coreutils
	dconf
	dosfstools
    discord
	ffmpeg-full
	fzf
	gdb
	grim
	htop
	hugo
    keepassxc
    loupe
	libnotify
	libreoffice-qt6-fresh
	libsecret
    librewolf
	nixvim
	ntfs3g
	pavucontrol
	powertop
	ripgrep
	signal-desktop
	slurp
	spotify
	swayidle
	tdesktop
	transmission_4
	typst
	udiskie
    unrar
	unzip
	usbutils
	wakeonlan
	wget
	wl-clipboard
    lm_sensors
	wofi
	yt-dlp
	zathura
    btop
    mpv
    fastfetch
    tree
    vlc
    qalculate-qt
	];

	# set session vars
	home.sessionVariables = {
        EDITOR="nvim";
        XDG_SESSION_TYPE = "wayland";
        NIXPKGS_ALLOW_UNFREE = 1;
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        GSK_RENDERER="ngl";
	};
}

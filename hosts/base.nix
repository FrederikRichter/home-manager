{config, pkgs, inputs, lib, ... }:
let
	# create nix file loader function
	modulesDir = ../modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));
	nixvim = inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
	# Setup home constants
	home.username = "frederik";
	home.homeDirectory = "/home/frederik";

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	targets.genericLinux.enable = lib.mkDefault true;

	home.stateVersion = lib.mkDefault "25.11";

	# load all nix files from ./modules
	imports = map (f: modulesDir + "/${f}") moduleFiles;

	# define home packages
	home.packages = with pkgs; [
	android-tools
	ausweisapp
	bash
	blender
	coreutils
	dconf
	dosfstools
	ffmpeg-full
	fzf
	gdb
	gtrash
	grim
	godot
	htop
	hugo
    helium
	keepassxc
	loupe
	libnotify
	libreoffice-qt
	libsecret
    localsend
	nixvim
	ntfs3g
	pavucontrol
	powertop
	ripgrep
	signal-desktop
	slurp
	spotify
	swayidle
	telegram-desktop
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
	overskride
	fastfetch
	tree
	nemo
	vlc
	rquickshare
	qalculate-qt
	];

	# set session vars
	home.sessionVariables = {
		EDITOR="nvim";
		XDG_SESSION_TYPE = "wayland";
		XDG_CURRENT_DESKTOP = "Hyprland";
		XDG_SESSION_DESKTOP = "Hyprland";
		GSK_RENDERER="ngl"; # HOTFIX
		WEBKIT_DISABLE_COMPOSITING_MODE=1; # HOTFIX
	};

	# Allow unfree packages both inside Home Manager and for user-level nix
	# commands (e.g. `nix-shell -p`, `nix build`, `nix-env`). See
	# https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree
	nixpkgs.config.allowUnfree = true;
	xdg.configFile."nixpkgs/config.nix".text = ''
		{ allowUnfree = true; }
	'';
}

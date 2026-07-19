{config, pkgs, inputs, lib, ... }:
let	
	# create nix file loader function
	modulesDir = ../modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));
    nixvim = inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    
    

	inherit pkgs;
	inherit inputs;
in
{
	# Setup home constants
	home.username = "frederik";
	home.homeDirectory = "/home/frederik";


	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	targets.genericLinux.enable = lib.mkDefault true;

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
    keepassxc
    loupe
	libnotify
	libreoffice-qt6-fresh
	libsecret
    librewolf-bin
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
        NIXPKGS_ALLOW_UNFREE = 1;
        EDITOR="nvim";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        GSK_RENDERER="ngl"; # HOTFIX
        WEBKIT_DISABLE_COMPOSITING_MODE=1; # HOTFIX
	};

    systemd.user.sessionVariables = {
    };
}

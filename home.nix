{config, pkgs, inputs, ... }:
let	
	# create nix file loader function
	modulesDir = ./modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));

	# mkgl = import ./scripts/mkgl.nix pkgs;

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
    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);  # Allows all unfree packages
        };
    };
    

	# load all nix files from ./modules
	imports = map (f: modulesDir + "/${f}") moduleFiles ++ [ inputs.stylix.homeManagerModules.stylix ];

	# define home packages
	home.packages = with pkgs; [
	# cli
        btop
        neofetch
		htop
		yt-dlp
		powertop
		thefuck
        nixvim
        hugo
        docker
# dev/libs
        gvfs
        udiskie
        usbutils
        libnotify
        bash
        dconf
        i2p
        fzf
        texliveFull
        gdb
		unzip
		ripgrep
		gcc
		wget
		gnupg
		gnumake
		coreutils
		ffmpeg-full
        libsecret
		cmake
		nixgl.auto.nixGLDefault
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
		python312
	# append gl dependent programs
		] ++  [ #map (mkgl)
		firefox
        calibre
        xournalpp
		tdesktop
		inkscape
        signal-desktop
        discord
        pavucontrol
        mpv
        spotify
        simplex-chat-desktop
        zathura
		];
	
	# direct file access
	home.file = {
	};
	
	# set session vars
	home.sessionVariables = {
        EDITOR="nvim";
        SHELL="zsh";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
	};
}

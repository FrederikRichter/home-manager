{
    description = "Home Manager configuration of frederik";

    inputs = {
# Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixvim = {
            url = "github:FrederikRichter/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:danth/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = {nixpkgs, ... }@inputs:
        let
        username = builtins.getEnv "USER";
        system = "x86_64-linux";
        # Overlays
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
    in {
        homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
# Specify your home configuration modules here, for example,
# the path to your home.nix.
            inherit pkgs;
            modules = [ ./home.nix inputs.stylix.homeManagerModules.stylix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
            };
# Optionally use extraSpecialArgs
# to pass through arguments to home.nix
        };
    };
}

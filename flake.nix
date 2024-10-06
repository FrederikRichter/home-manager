{
    description = "Home Manager configuration of hm-testing";

    inputs = {
# Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-parts = {
            url = "github:hercules-ci/flake-parts";
            inputs.nixpkgs-lib.follows = "nixpkgs";
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
        nixvimOverlay = final: prev: {
            nixvim = inputs.nixvim.packages.${system}.default;
        };
        pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ nixvimOverlay ];
        };
    in {
        homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
# Specify your home configuration modules here, for example,
# the path to your home.nix.
            inherit pkgs;
            modules = [ ./home.nix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit pkgs;
            };
# Optionally use extraSpecialArgs
# to pass through arguments to home.nix
        };
    };
}

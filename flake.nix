{
    description = "Home Manager configuration by FrederikRichter";

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
        noctalia = {
            url = "github:noctalia-dev/noctalia-shell";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, ... }@inputs:
        let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };

        stylixModule = inputs.stylix.homeModules.stylix;

        mkHost = hostModule: inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./hosts/base.nix hostModule stylixModule ];
            extraSpecialArgs = {
                inherit inputs;
            };
        };
    in {
        homeConfigurations."thinkpad"      = mkHost ./hosts/thinkpad.nix;
        homeConfigurations."ideapad"       = mkHost ./hosts/ideapad.nix;
        homeConfigurations."battlestation" = mkHost ./hosts/battlestation.nix;
    };
}

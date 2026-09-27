{
    description = "Home Manager configuration by FrederikRichter";

    inputs = {
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
        helium = {
            url = "github:FrederikRichter/helium-browser-nix-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };        
        evolved = {
            url = "github:FrederikRichter/evolve-stage2-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };        
    };

    outputs = { nixpkgs, ... }@inputs:
        let
        system = "x86_64-linux";

        overlays = [
            inputs.helium.overlays.default
            inputs.evolved.overlays.default
            (final: prev: {
                nixvim = inputs.nixvim.packages.${prev.stdenv.hostPlatform.system}.default;
                nvim = inputs.nixvim.packages.${prev.stdenv.hostPlatform.system}.default;
                evolved = final.modded-evolve;
            })
        ];

        pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
        };

        stylixModule = inputs.stylix.homeModules.stylix;

        mkHost = hostModule: inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
                {
                    nixpkgs.overlays = overlays;
                }
                ./hosts/base.nix
                hostModule
                stylixModule
            ];
            extraSpecialArgs = {
                inherit inputs;
            };
        };
    in {
        overlays.default = nixpkgs.lib.composeManyExtensions overlays;
        homeConfigurations."ideapad"       = mkHost ./hosts/ideapad.nix;
        homeConfigurations."battlestation" = mkHost ./hosts/battlestation.nix;
    };
}

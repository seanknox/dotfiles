{
  description = "Nix Configuration";

  inputs = {
    # Package sources
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    # Home manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Darwin system configuration (for macOS settings)
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      # Get system type (aarch64-darwin for Apple Silicon, x86_64-darwin for Intel)
      system = builtins.currentSystem;
      pkgs = nixpkgs.legacyPackages.${system};
      
      # This will create configurations for any username
      mkConfig = { 
        username,
        system ? builtins.currentSystem,
        homeDirectory ? "/Users/${username}"
      }: {
        # Home Manager configuration
        homeConfig = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./home.nix
            {
              # Pass these as configuration values that can be accessed in home.nix
              home = {
                inherit username homeDirectory;
              };
            }
          ];
          extraSpecialArgs = { inherit inputs username homeDirectory; };
        };
        
        # Darwin configuration (for macOS settings)
        darwinConfig = darwin.lib.darwinSystem {
          inherit system;
          modules = [ 
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              # Pass these values to home-manager module
              home-manager.extraSpecialArgs = {
                inherit username homeDirectory;
              };
            }
          ];
          specialArgs = { inherit inputs username homeDirectory; };
        };
      };
    in {
      # Get current user from environment
      homeConfigurations."current" = (mkConfig { 
        username = builtins.getEnv "USER";
      }).homeConfig;
      
      darwinConfigurations."current" = (mkConfig { 
        username = builtins.getEnv "USER";
      }).darwinConfig;
    };
} 

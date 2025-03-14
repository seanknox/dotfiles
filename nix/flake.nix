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
    {
      # Default configuration that can be used regardless of hostname or username
      darwinConfigurations.default = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # Change to x86_64-darwin for Intel Macs
        modules = [ 
          ./darwin-configuration.nix
          {
            # Disable nix management by nix-darwin to prevent conflicts with Determinate Systems
            nix.enable = false;
          }
        ];
      };
    };
} 

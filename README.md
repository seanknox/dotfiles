# Nix Configuration for macOS

This repository contains a declarative Nix configuration for macOS using nix-darwin and Home Manager.

## Setup

The `setup.sh` script automates the installation and configuration process:

1. Installs Xcode Command Line Tools (if needed)
2. Installs Nix using the Determinate Systems installer
3. Installs nix-darwin using the modern flakes approach
4. Applies the configuration using flakes

To get started:

```bash
# Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Make the setup script executable
chmod +x setup.sh

# Run the setup script
./setup.sh
```

## Configuration Structure

- `nix/flake.nix`: The main entry point for the Nix configuration
- `nix/darwin-configuration.nix`: macOS system settings managed by nix-darwin
- `nix/home-test.nix`: User environment settings managed by Home Manager

## Recent Changes

- Updated to use the modern flakes-based approach for installing nix-darwin
- Added `nix.enable = false` to prevent conflicts with the Determinate Systems Nix installer
- Removed the outdated bootstrap configuration approach
- Simplified the setup process

## Troubleshooting

If you encounter issues with the setup script:

1. Make sure you have internet connectivity
2. Check that you have sufficient permissions
3. If the script fails at the nix-darwin installation step, you can try running the commands manually:

```bash
# Install nix-darwin using flakes
nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake .

# Or alternatively
nix build .#darwinConfigurations.current.system --experimental-features "nix-command flakes"
./result/sw/bin/darwin-rebuild switch --flake .
```

## Customization

To customize your configuration:

1. Edit `nix/darwin-configuration.nix` for macOS system settings
2. Edit `nix/home-test.nix` for user environment settings
3. Run `darwin-rebuild switch --flake .` to apply changes

## References

- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Determinate Systems Nix Installer](https://determinate.systems/posts/nix-darwin-updates/)

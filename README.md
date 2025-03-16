# Nix Configuration

This repository contains a streamlined Nix configuration for setting up a macOS development environment with nix-darwin and Home Manager.

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

The setup script will:
- Install Xcode Command Line Tools
- Install Nix with flakes enabled
- Set up and configure nix-darwin
- Apply the default configuration

## What's Included

- **Nix**: The purely functional package manager
- **nix-darwin**: For managing macOS system configuration
- **Home Manager**: For managing user environment

## After Installation

After running the setup script, you'll need to restart your terminal or run:
```bash
exec $SHELL
```

## Updating Your Configuration

To apply changes to your configuration:

1. Make sure you're in the repository directory:
   ```bash
   cd ~/.dotfiles
   ```

2. Run:
   ```bash
   darwin-rebuild switch --flake .#default
   ```

## Structure

- `setup.sh`: Bootstrap script for first-time setup
- `flake.nix`: The entry point for the Nix configuration
- `home.nix`: Home Manager configuration for user environment
- `darwin-configuration.nix`: macOS-specific settings

## Customization

- To add new packages, edit the `home.packages` list in `home.nix`
- To modify macOS settings, edit `darwin-configuration.nix`
- To update the configuration, run the appropriate build command again

## Troubleshooting

- If you encounter issues with the Nix daemon, try restarting it:
  ```bash
  sudo launchctl kickstart -k system/org.nixos.nix-daemon
  ```

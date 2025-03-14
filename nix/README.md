# Nix Configuration

This directory contains the Nix configuration for setting up a macOS development environment.

## Prerequisites

1. Install Nix:
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. Enable flakes by creating or editing `/etc/nix/nix.conf`:
   ```
   experimental-features = nix-command flakes
   ```

3. Install nix-darwin:
   ```bash
   nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
   ./result/bin/darwin-installer
   ```

## Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. (Optional) Create machine-specific Git configuration:
   ```bash
   # Create a machine-specific Git config for overrides
   cat > ~/.gitconfig.local << EOF
   [user]
     # Override email for work machine
     email = your.work.email@example.com
   EOF
   ```

3. Build and activate the configuration:
   ```bash
   cd ~/.dotfiles/nix
   
   # For just home-manager configuration
   nix run home-manager/master -- switch --flake .#current
   
   # For full darwin system configuration (including macOS settings)
   darwin-rebuild switch --flake .#current
   ```

## Dynamic User Configuration

This configuration automatically detects the current user and home directory, making it portable across different machines with different usernames. The configuration:

1. Uses `builtins.getEnv "USER"` to get the current username
2. Constructs the home directory path based on the username
3. Creates configurations that work on any machine without hardcoding usernames

## Machine-Specific Customization

For machine-specific settings:

1. **Git Configuration**: 
   - Your Git configuration is managed by Home Manager and will generate a `.gitconfig` file
   - For machine-specific overrides (like different email addresses), create a `~/.gitconfig.local` file
   - The main configuration includes this file automatically

2. **Other Settings**:
   - You can create machine-specific configurations by adding them to the flake.nix file

## Structure

- `flake.nix`: The entry point for the Nix configuration
- `home.nix`: Home Manager configuration for user environment
- `darwin-configuration.nix`: macOS-specific settings

## Customization

- To add new packages, edit the `home.packages` list in `home.nix`
- To modify macOS settings, edit `darwin-configuration.nix`
- To update the configuration, run the appropriate build command again

## Migration Plan

This configuration is part of a phased migration from Homebrew to Nix. See the `nix-migration-plan.md` file in the repository root for details on the migration process.

## Troubleshooting

- If you encounter issues with the Nix daemon, try restarting it:
  ```bash
  sudo launchctl kickstart -k system/org.nixos.nix-daemon
  ```

- If a package isn't available or working correctly in Nix, you can temporarily keep using it via Homebrew until a solution is found.

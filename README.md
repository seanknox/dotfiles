# Sean Knox's Dotfiles

A complete, reproducible macOS development environment managed through Nix.

## Overview

This repository contains my personal dotfiles and system configuration using the Nix package manager, Home Manager, and nix-darwin. It provides a declarative, reproducible setup for macOS that can be easily deployed on new machines.

## Features

- **Declarative Configuration**: All settings defined in code
- **Reproducible Environment**: Same setup across all machines
- **macOS System Preferences**: Automatically configured
- **Development Tools**: Git, shell utilities, and programming languages
- **Application Management**: Both CLI and GUI applications
- **Cross-Machine Support**: Works with different usernames and machine types
- **Flakes Support**: Uses Determinate Nix Installer with flakes enabled by default

## Quick Start

To bootstrap a new macOS machine with this configuration, run:

```bash
curl -L https://raw.githubusercontent.com/seanknox/dotfiles/main/bootstrap.sh | bash
```

This single command will:
1. Install Xcode Command Line Tools
2. Accept the Xcode license
3. Install Nix using the Determinate Nix Installer (with flakes enabled)
4. Clone this repository
5. Set up nix-darwin and Home Manager
6. Guide you through the next steps

## Manual Installation

If you prefer to install step by step:

1. **Install Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   sudo xcodebuild -license accept
   ```

2. **Install Nix using Determinate Nix Installer**:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

3. **Clone this repository**:
   ```bash
   git clone https://github.com/seanknox/dotfiles.git ~/.dotfiles
   ```

4. **Install nix-darwin**:
   ```bash
   cd ~/.dotfiles
   nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
   ./result/bin/darwin-installer
   ```

5. **Install Home Manager**:
   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
   nix-channel --update
   nix-shell '<home-manager>' -A install
   ```

6. **Apply the configuration**:
   ```bash
   darwin-rebuild switch
   ```

## Testing the Configuration

Before applying the configuration to your main system, you can test it in a safe environment:

1. **Using the lint script**:
   ```bash
   cd ~/.dotfiles/nix-test
   ./nix-lint.sh
   ```
   This script checks your Nix configuration syntax and package resolution without modifying anything.

2. **Using a macOS VM**:
   - Install UTM from [getutm.app](https://mac.getutm.app/)
   - Create a macOS VM
   - Run the bootstrap script inside the VM

## Configuration Structure

- `flake.nix`: Entry point with home-manager and nix-darwin setup
- `home.nix`: User environment configuration (packages, git, shell)
- `darwin-configuration.nix`: macOS-specific settings

## Customization

To customize this configuration for your own use:

1. Fork this repository
2. Update the Git configuration in `home.nix` with your details
3. Modify the package list to suit your needs
4. Adjust macOS settings in `darwin-configuration.nix`
5. Update the repository URL in `bootstrap.sh`

## Updating

To update your system after making changes:

```bash
cd ~/.dotfiles
git pull  # If you want to pull the latest changes
darwin-rebuild switch
```

## Troubleshooting

- **Bootstrap fails**: Check the error message and fix the specific issue
- **Configuration doesn't apply**: Check logs in `~/.nix/var/log/nix/darwin-rebuild.log`
- **Package not found**: Make sure it's available in nixpkgs or add a custom source
- **Flakes issues**: The Determinate Nix Installer enables flakes by default, so you shouldn't need to enable them manually

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Nix](https://nixos.org/)
- [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer)
- [Home Manager](https://github.com/nix-community/home-manager)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [MikeMcQuaid/strap](https://github.com/MikeMcQuaid/strap) - Inspiration for the bootstrap approach

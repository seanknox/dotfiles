#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Nix Configuration Bootstrap${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}This bootstrap script is only for macOS${NC}"
    exit 1
fi

# Install Xcode Command Line Tools
if ! command_exists xcode-select; then
    echo -e "${YELLOW}Installing Xcode Command Line Tools...${NC}"
    xcode-select --install || {
        echo -e "${RED}Failed to install Xcode Command Line Tools${NC}"
        exit 1
    }
fi

# Accept Xcode license
echo -e "${YELLOW}Accepting Xcode license...${NC}"
sudo xcodebuild -license accept || {
    echo -e "${RED}Failed to accept Xcode license${NC}"
    exit 1
}

# Install Nix using Determinate Nix Installer
if ! command_exists nix; then
    echo -e "${YELLOW}Installing Nix using Determinate Nix Installer...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install || {
        echo -e "${RED}Failed to install Nix${NC}"
        exit 1
    }
fi

# Source Nix environment
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Clone dotfiles repository
echo -e "${YELLOW}Cloning dotfiles repository...${NC}"
if [ ! -d ~/.dotfiles ]; then
    git clone https://github.com/seanknox/dotfiles.git ~/.dotfiles || {
        echo -e "${RED}Failed to clone dotfiles repository${NC}"
        exit 1
    }
fi

# Change to dotfiles directory
cd ~/.dotfiles

# Install nix-darwin
echo -e "${YELLOW}Installing nix-darwin...${NC}"
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer || {
    echo -e "${RED}Failed to install nix-darwin${NC}"
    exit 1
}

# Install Home Manager
echo -e "${YELLOW}Installing Home Manager...${NC}"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install || {
    echo -e "${RED}Failed to install Home Manager${NC}"
    exit 1
}

echo -e "${GREEN}Bootstrap completed successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal to ensure all environment variables are set"
echo "2. Run 'darwin-rebuild switch' to apply your configuration"
echo "3. If you encounter any issues, check the logs in ~/.nix/var/log/nix/darwin-rebuild.log" 

#!/bin/bash
# Initial bootstrap script for macOS with Nix, nix-darwin, and Home Manager
# This script is designed for first-time setup only

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Simple logging functions
log() { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}==>${NC} $*"; }
error() { echo -e "${RED}==>${NC} $*"; exit 1; }

log "Starting initial macOS Nix bootstrap"

# Pre-flight checks to ensure this is a fresh system
if command -v nix &>/dev/null; then
    error "Nix is already installed. This script is for initial setup only."
fi

if command -v darwin-rebuild &>/dev/null; then
    error "nix-darwin is already installed. This script is for initial setup only."
fi

# Step 2: Install Xcode Command Line Tools
log "Installing Xcode Command Line Tools"
xcode-select --install || true
  
# Wait for installation to complete
log "Waiting for Xcode Command Line Tools installation to complete..."
until [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; do
    sleep 5
done
success "Xcode Command Line Tools installed"

# Step 3: Accept Xcode license
log "Accepting Xcode license"
sudo xcodebuild -license accept
success "Xcode license accepted"

# Step 4: Install Nix with flakes
log "Installing Nix with flakes"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

# Source Nix environment
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
success "Nix installed successfully"

# Step 5: Install and configure nix-darwin
log "Installing and configuring nix-darwin"

# Use current directory for configuration files
CONFIG_DIR="$(pwd)"
log "Using configuration files from: $CONFIG_DIR"

# Backup /etc files that might conflict with nix-darwin
log "Backing up /etc files that might conflict with nix-darwin..."
if [ -f "/etc/pam.d/sudo_local" ]; then
    sudo mv /etc/pam.d/sudo_local /etc/pam.d/sudo_local.before-nix-darwin
    log "Backed up /etc/pam.d/sudo_local"
fi

# Install and configure nix-darwin
log "Building default darwin configuration..."
nix build .#darwinConfigurations.default.system --experimental-features "nix-command flakes"

log "Activating darwin configuration..."
./result/sw/bin/darwin-rebuild switch --flake .#default

success "Setup complete! Your macOS has been configured with Nix."
log "You need to restart your terminal or run 'exec \$SHELL' for all changes to take effect."
log "To reapply changes to your configuration in the future:"
log "1. Make sure you're in this directory ($(pwd))"
log "2. Run: darwin-rebuild switch --flake .#default"

#!/bin/bash
# Simple setup script for macOS with Nix, nix-darwin, and Home Manager
# Focused on clear steps with minimal complexity

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

log "Starting macOS Nix setup"

# Step 1: Initialize sudo to prevent prompts later
sudo --reset-timestamp

# Step 2: Install Xcode Command Line Tools
log "Step 2: Installing Xcode Command Line Tools"
if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
  log "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  
  # Wait for installation to complete
  log "Waiting for Xcode Command Line Tools installation to complete..."
  until [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; do
    sleep 5
  done
  success "Xcode Command Line Tools installed"
else
  success "Xcode Command Line Tools already installed"
fi

# Step 3: Accept Xcode license if needed
log "Step 3: Accepting Xcode license"
if /usr/bin/xcrun clang 2>&1 | grep -q license; then
  sudo xcodebuild -license accept
  success "Xcode license accepted"
fi

# Step 4: Install Nix with flakes enabled
log "Step 4: Installing Nix with flakes"
if ! command -v nix &>/dev/null; then
  log "Installing Nix using Determinate Systems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  
  # Source Nix environment
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  success "Nix installed successfully"
else
  success "Nix already installed"
fi

# Step 5: Install and configure nix-darwin
log "Step 5: Installing and configuring nix-darwin"

# Use current directory for configuration files
CONFIG_DIR="$(pwd)"
FLAKE_DIR="${CONFIG_DIR}/nix"
log "Using configuration files from: $CONFIG_DIR"
log "Flake directory: $FLAKE_DIR"

# Backup /etc files that might conflict with nix-darwin
log "Backing up /etc files that might conflict with nix-darwin..."
if [ -f "/etc/pam.d/sudo_local" ]; then
  sudo mv /etc/pam.d/sudo_local /etc/pam.d/sudo_local.before-nix-darwin
  log "Backed up /etc/pam.d/sudo_local"
fi

# Install nix-darwin if not already installed
if ! command -v darwin-rebuild &>/dev/null; then
  log "Installing nix-darwin using flakes..."
  
  # Build the default configuration
  cd "$FLAKE_DIR"
  log "Building default darwin configuration..."
  nix build .#darwinConfigurations.default.system --experimental-features "nix-command flakes"
  
  # Then activate it
  log "Activating darwin configuration..."
  ./result/sw/bin/darwin-rebuild switch --flake .#default
  
  success "nix-darwin installed"
else
  # Apply configuration using flake if darwin-rebuild is already installed
  log "Applying configuration using flake..."
  cd "$FLAKE_DIR"
  darwin-rebuild switch --flake .#default "nix-command flakes"
fi

success "Setup complete! Your macOS has been configured with Nix."
log "You need to restart your terminal or run 'exec \$SHELL' for all changes to take effect."

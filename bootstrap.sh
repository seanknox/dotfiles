#!/bin/bash
# Bootstrap script for setting up a new macOS machine with Nix
# Heavily inspired by https://github.com/MikeMcQuaid/strap/blob/main/strap.sh

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Logging functions
log() { echo -e "${YELLOW}$*${NC}"; }
logn() { printf "${YELLOW}%s${NC}" "$*"; }
logk() { echo -e "${GREEN}OK${NC}"; }
logf() { echo -e "${RED}$*${NC}"; exit 1; }

# Helper function for sudo with password
sudo_askpass() {
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass "$@"
  else
    sudo "$@"
  fi
}

# Cleanup function
cleanup() {
  set +e
  sudo_askpass rm -rf "$CLT_PLACEHOLDER" 2>/dev/null
  sudo --reset-timestamp
}

# Set up trap to ensure cleanup happens
trap "cleanup" EXIT

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  logf "This bootstrap script is only for macOS"
fi

# Get macOS version
macos_version=$(sw_vers -productVersion)
log "Detected macOS version: $macos_version"

# We want to always prompt for sudo password at least once
sudo --reset-timestamp

# Install the Xcode Command Line Tools
if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
  log "Installing the Xcode Command Line Tools:"
  
  # Create the placeholder file that triggers the CLT installation
  CLT_PLACEHOLDER="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  sudo_askpass touch "$CLT_PLACEHOLDER"
  
  # Find the latest Command Line Tools package
  CLT_PACKAGE=$(softwareupdate -l | 
    grep -B 1 "Command Line Tools" | 
    awk -F"*" '/^ *\*/ {print $2}' | 
    sed -e 's/^ *Label: //' -e 's/^ *//' | 
    sort -V | 
    tail -n1)
  
  if [ -n "$CLT_PACKAGE" ]; then
    log "Installing $CLT_PACKAGE"
    sudo_askpass softwareupdate -i "$CLT_PACKAGE" --verbose
    sudo_askpass rm -f "$CLT_PLACEHOLDER"
  else
    log "No Command Line Tools package found in softwareupdate"
    sudo_askpass rm -f "$CLT_PLACEHOLDER"
    
    # Only as a last resort, try the interactive method
    log "Trying alternative installation method"
    xcode-select --install &>/dev/null || true
    
    # Give clear instructions
    log "If a dialog appears, please click 'Install' to install the Command Line Tools"
    log "Waiting for Command Line Tools installation to complete..."
    
    # Wait for the installation to complete (up to 5 minutes)
    for i in {1..30}; do
      if [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
        break
      fi
      echo -n "."
      sleep 10
    done
    echo
  fi
  
  # Verify the installation
  if [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
    logk
  else
    logf "Command Line Tools installation failed. Please install manually with 'xcode-select --install' and try again."
  fi
fi

# Check if the Xcode license is agreed to and agree if not
if /usr/bin/xcrun clang 2>&1 | grep -q license; then
  log "Accepting Xcode license:"
  sudo_askpass xcodebuild -license accept
  logk
fi

# Install Nix using Determinate Nix Installer
if ! command -v nix &>/dev/null; then
  log "Installing Nix using Determinate Nix Installer:"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  
  # Source Nix environment
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
  fi
  
  # Verify Nix installation
  if command -v nix &>/dev/null; then
    logk
  else
    logf "Nix installation failed. Please check the logs and try again."
  fi
else
  log "Nix is already installed"
  logk
fi

# Clone or update dotfiles repository
log "Setting up dotfiles repository:"
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/seanknox/dotfiles.git "$HOME/.dotfiles"
  logk
else
  log "Dotfiles repository already exists, updating:"
  (cd "$HOME/.dotfiles" && git pull)
  logk
fi

# Change to dotfiles directory
cd "$HOME/.dotfiles"

# Install nix-darwin
log "Installing nix-darwin:"
if ! command -v darwin-rebuild &>/dev/null; then
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  logk
else
  log "nix-darwin is already installed"
  logk
fi

# Install Home Manager
log "Installing Home Manager:"
if ! command -v home-manager &>/dev/null; then
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  logk
else
  log "Home Manager is already installed"
  logk
fi

log "Bootstrap completed successfully!"
log "Next steps:"
echo "1. Restart your terminal to ensure all environment variables are set"
echo "2. Run 'darwin-rebuild switch' to apply your configuration"
echo "3. If you encounter any issues, check the logs in ~/.nix/var/log/nix/darwin-rebuild.log" 

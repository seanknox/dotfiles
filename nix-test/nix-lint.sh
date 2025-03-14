#!/bin/bash
# Test script for validating Nix configuration without applying it

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

# Check if we're in the right directory
if [ ! -d "../nix" ]; then
  logf "This script must be run from the nix-test directory."
fi

cd ..

# Check if nix is installed
if ! command -v nix &>/dev/null; then
  logf "Nix is not installed. Please run bootstrap.sh first."
fi

log "Testing flake.nix syntax..."
nix flake check ./nix || logf "Flake check failed!"
logk

log "Testing nix-darwin configuration..."
darwin-rebuild check --flake ./nix#current || logf "nix-darwin configuration check failed!"
logk

log "Testing Home Manager configuration..."
# This command evaluates the Home Manager configuration without applying it
nix eval --impure --raw ./nix#homeConfigurations.current.activationPackage || logf "Home Manager configuration check failed!"
logk

log "All tests passed! Your Nix configuration is valid."
log "You can safely apply it with: ./activate.sh" 

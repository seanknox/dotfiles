#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

NIX_DIR="../nix"

echo -e "${BLUE}Nix Configuration Linter${NC}"
echo "This script checks Nix configuration syntax and package resolution."
echo

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo -e "${RED}Error: Nix is not installed.${NC}"
    echo "This script requires Nix to check configuration syntax and package resolution."
    echo "Install Nix using: curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

# Function to check if a file exists
check_file_exists() {
    local file=$1
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file exists${NC}"
        return 0
    else
        echo -e "${RED}✗ $file does not exist${NC}"
        return 1
    fi
}

# Function to check Nix syntax
check_nix_syntax() {
    local file=$1
    echo -e "\n${YELLOW}Checking syntax for $file...${NC}"
    
    if nix-instantiate --parse "$file" &> /dev/null; then
        echo -e "${GREEN}✓ $file syntax is valid${NC}"
        return 0
    else
        echo -e "${RED}✗ $file has syntax errors:${NC}"
        nix-instantiate --parse "$file" 2>&1 | sed 's/^/  /'
        return 1
    fi
}

# Function to check if packages can be resolved
check_package_resolution() {
    echo -e "\n${YELLOW}Checking package resolution...${NC}"
    
    # Create a temporary file with a subset of packages from home.nix
    local temp_file=$(mktemp)
    cat > "$temp_file" << 'EOF'
let
  pkgs = import <nixpkgs> {};
in
[
  # Basic CLI tools
  pkgs.jq
  pkgs.bat
  pkgs.ripgrep
  pkgs.fd
  pkgs.tree
]
EOF
    
    if nix eval --file "$temp_file" &> /dev/null; then
        echo -e "${GREEN}✓ Basic packages can be resolved${NC}"
        rm "$temp_file"
        return 0
    else
        echo -e "${RED}✗ Some packages cannot be resolved:${NC}"
        nix eval --file "$temp_file" 2>&1 | sed 's/^/  /'
        rm "$temp_file"
        return 1
    fi
}

# Function to check flake.nix
check_flake() {
    local file="$NIX_DIR/flake.nix"
    echo -e "\n${YELLOW}Checking flake.nix...${NC}"
    
    # First check if file exists
    if ! check_file_exists "$file"; then
        return 1
    fi
    
    # Check flake syntax
    if cd "$NIX_DIR" && nix flake check --no-build &> /dev/null; then
        echo -e "${GREEN}✓ flake.nix is valid${NC}"
        return 0
    else
        echo -e "${RED}✗ flake.nix has errors:${NC}"
        (cd "$NIX_DIR" && nix flake check --no-build 2>&1) | sed 's/^/  /'
        return 1
    fi
}

# Main execution
echo -e "${BLUE}Step 1: Checking if required files exist${NC}"
required_files=("$NIX_DIR/flake.nix" "$NIX_DIR/home.nix" "$NIX_DIR/darwin-configuration.nix")
files_exist=true

for file in "${required_files[@]}"; do
    if ! check_file_exists "$file"; then
        files_exist=false
    fi
done

if [ "$files_exist" = false ]; then
    echo -e "\n${RED}Error: Some required files are missing.${NC}"
    echo "Please make sure all required Nix configuration files exist."
    exit 1
fi

echo -e "\n${BLUE}Step 2: Checking Nix syntax${NC}"
syntax_valid=true

for file in "${required_files[@]}"; do
    if ! check_nix_syntax "$file"; then
        syntax_valid=false
    fi
done

echo -e "\n${BLUE}Step 3: Checking flake.nix${NC}"
flake_valid=true

if ! check_flake; then
    flake_valid=false
fi

echo -e "\n${BLUE}Step 4: Checking package resolution${NC}"
packages_valid=true

if ! check_package_resolution; then
    packages_valid=false
fi

# Print summary
echo -e "\n${BLUE}Lint Summary:${NC}"
if [ "$syntax_valid" = true ] && [ "$flake_valid" = true ] && [ "$packages_valid" = true ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some checks failed.${NC}"
    [ "$syntax_valid" = false ] && echo -e "${RED}  - Syntax check failed${NC}"
    [ "$flake_valid" = false ] && echo -e "${RED}  - Flake check failed${NC}"
    [ "$packages_valid" = false ] && echo -e "${RED}  - Package resolution failed${NC}"
    exit 1
fi 

#!/bin/zsh

# This script appends fnm setup to ~/.zshrc and installs Node.js and Yarn

# Append fnm setup to ~/.zshrc
cat << 'EOF' >> ~/.zshrc

## setup fnm
eval "$(fnm env --use-on-cd --shell zsh)"
EOF


# Create NVM directory if it doesn't exist
mkdir -p "$HOME/.nvm"

source ~/.zshrc

# install latest stable node
fnm install v22.14.0
fnm use v22.14.0
fnm alias default v22.14.0

#!/bin/zsh

# This script appends NVM setup to ~/.zshrc and installs Node.js and Yarn

# Append NVM setup to ~/.zshrc
cat << 'EOF' >> ~/.zshrc

## setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion 
EOF

# Create NVM directory if it doesn't exist
mkdir -p "$HOME/.nvm"

source ~/.zshrc

# install latest stable node
nvm install node
nvm use node
nvm alias default node

# install yarn
npm install -g yarn

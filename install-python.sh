#!/bin/zsh

# This script appends pyenv setup to ~/.zshrc and installs Python

# Append pyenv setup to ~/.zshrc
cat << 'EOF' >> ~/.zshrc

## setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
EOF

source ~/.zshrc

pyenv install 3.12.9
pyenv global 3.12.9 


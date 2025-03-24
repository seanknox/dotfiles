#!/bin/sh

starship preset gruvbox-rainbow -o ~/.dotfiles/starship/gruvbox-rainbow.toml

echo "eval \"$(starship init zsh)\"" >> ~/.zshrc


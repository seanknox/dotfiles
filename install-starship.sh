#!/bin/sh
echo '#install starship' >> ~/.zshrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc


starship preset gruvbox-rainbow -o ~/.dotfiles/starship/gruvbox-rainbow.toml



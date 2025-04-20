#!/bin/sh
echo '#install starship' >> ~/.zshrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

mkdir -p ~/.config/starship
cp starship/gruvbox-rainbow-k8s.toml ~/.config/starship.toml   

#!/bin/sh

mkdir -p /opt/homebrew/etc/profile.d || { echo "couldn't create /opt/homebrew/etc/profile.d"; exit 1; }
curl -sk https://raw.githubusercontent.com/rupa/z/master/z.sh >> /opt/homebrew/etc/profile.d/z.sh

echo "\n# shellcheck disable=SC1091" >> "${HOME}/.zshrc"
echo "source /opt/homebrew/etc/profile.d/z.sh" >> "${HOME}/.zshrc"

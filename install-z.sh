#!/bin/sh

mkdir -p /usr/local/etc/profile.d || { echo "couldn't create /usr/local/etc/profile.d"; exit 1; }
curl -sk https://raw.githubusercontent.com/rupa/z/master/z.sh >> /usr/local/etc/profile.d/z.sh

echo "\n# shellcheck disable=SC1091" >> "${HOME}/.zshrc"
echo "source /usr/local/etc/profile.d/z.sh" >> "${HOME}/.zshrc"
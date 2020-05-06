#!/bin/sh

mkdir -p /usr/local/etc/profile.d || { echo "couldn't create /usr/local/etc/profile.d"; exit 1; }
curl -sk https://raw.githubusercontent.com/rupa/z/master/z.sh >> /usr/local/etc/profile.d/z.sh

echo "# shellcheck disable=SC1091
source /usr/local/etc/profile.d/z.sh" >> "${HOME}/.zshrc"
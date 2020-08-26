#!/bin/sh

set -e

gem install colorls

COLOR_LS_DIR=$(dirname "$(gem which colorls)")

echo "\n# shellcheck disable=SC1091" >> "${HOME}/.zshrc"
echo "source ${COLOR_LS_DIR}/tab_complete.sh" >> "${HOME}/.zshrc"

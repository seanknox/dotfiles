#!/bin/sh

set -e

gem install colorls

echo "# shellcheck disable=SC1091
source $(dirname "$(gem which colorls)")/tab_complete.sh" >> "${HOME}/.zshrc"

#!/bin/sh

set -e

brew bundle

for x in install-*.sh; do
  sh -c "./${x}"
done

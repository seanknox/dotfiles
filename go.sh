#!/bin/sh

set -e

for x in install-*.sh; do
  sh -c "./${x}"
done

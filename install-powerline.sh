#!/bin/sh

mkdir -p ~/src
(
  cd ~/src || { echo "couldn't switch to src/. does ~/src/src exist?"; exit 1; }
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts || { echo "couldn't switch to fonts/. does ~/src/fonts exist?"; exit 1; }
  ./install.sh
)

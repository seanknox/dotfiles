#!/bin/sh

# Navigate the a folder where we can download the zsh-syntax-highlighting script

# Note: if the zsh folder does not exists in /usr/local/share, just create it

(
  cd /usr/local/share/zsh || { echo "/usr/local/share/zsh does not exist"; exit 1; }

  # Clone the zsh-syntax-highlighting repo

  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

  # Add a startup script to your .zshrc to enable syntax highlighting in new shell sessions

  echo "# shellcheck disable=SC1091
source /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${HOME}/.zshrc"
)
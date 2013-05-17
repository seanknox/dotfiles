ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

exec $SHELL -l

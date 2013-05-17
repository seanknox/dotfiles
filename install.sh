ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf

exec $SHELL -l

echo "If this is a new installation, open vim and type ':BundleInstall' to install necessary vim plugins."

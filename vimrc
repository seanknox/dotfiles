" bring in the bundles for mac and windows
set rtp+=~/vimfiles/vundle.git/
set rtp+=~/.vim/vundle.git/
call vundle#rc()

runtime! common_config/*.vim
execute pathogen#infect()
syntax on
filetype plugin indent on
autocmd Filetype gitcommit setlocal spell textwidth=72

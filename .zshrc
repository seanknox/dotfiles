HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set window title to command just before running it.
preexec() { printf "\x1b]0;%s\x07" "$1"; }

# Set window title to current working directory after returning from a command.
precmd() { printf "\x1b]0;%s\x07" "$PWD"; }

## setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## setup rbenv
export PATH=~/.rbenv/shims:$PATH
eval "$(rbenv init -)"

alias be='bundle exec'
alias gp='git push'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long' # detailed list view

## add bin/ and $HOME/bin to PATH
export PATH=bin:$HOME/bin:$PATH

## setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

## add bin/ and $HOME/bin to PATH
export PATH=bin:$HOME/bin:$PATH

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

setopt NO_NOMATCH

# Customize to your needs...

# MAKE_OPTS to use 4 cores
export MAKE_OPTS="-j 8 -O3"

export EC2_HOME="/opt/boxen/homebrew/Cellar/ec2-api-tools/1.6.13.0/libexec"
#export EC2_URL=https://ec2.us-west-1.amazonaws.com
export GREP_OPTIONS='--color=auto'
export EGREP_OPTIONS='--color=auto'
export CLICOLOR=1
# export PS1='@\h \[\e[1;31m\]\W\[\e[1;33m\]$(parse_git_branch)\[\e[0;39m\]> '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
# export SSL_CERT_FILE=/usr/local/etc/openssl/cacert.pem
export EDITOR=vim

# Git
git config --global user.name "Sean Knox"
git config --global user.email "knoxville@gmail.com"

# Rails Aliases
alias be='bundle exec'
alias rc='rails console'
alias rs='rails server'
alias devlog='tail -f log/development.log'

# Misc Aliases
alias findn='find . -name'
alias line_count='xargs wc -l | sort -n -r'
alias history='history 1'
alias bower='noglob bower'

alias resh='exec $SHELL -l'

# parse_git_branch() {
#   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ →\ \1/'
# }

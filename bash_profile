export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin:/usr/local/mysql/bin:/Applications/Postgres.app/Contents/MacOS/bin
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib/
export AWS_ACCESS_KEY=
export AWS_SECRET_KEY=
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
export EC2_URL=https://ec2.us-west-1.amazonaws.com
export GREP_OPTIONS='--color=auto'
export EGREP_OPTIONS='--color=auto'
export CLICOLOR=1

# Use Hub to make git magical
alias git=hub

# Git
git config --global user.name "Sean Knox"
git config --global user.email "knoxville@gmail.com"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Git Aliases
alias gc='git commit -m'
alias ga='git add'
alias gp='git push'
alias gs='git status'
alias gap='git add -p'
alias gd='git difftool'
alias gdc='git difftool --cached'
alias gl='git hist'
alias gl5='git hist -5'
alias gl10='git hist -10'
alias gsa='git show'
alias gsf='git show --pretty="format:" --name-only'

# Rails Aliases
alias be='bundle exec'
alias rc='rails console'
alias rs='rails server'

# Misc Ruby Aliases
alias fs='foreman start -f'
alias sp='rspec -cfn'
alias r='rake'
alias z='zeus'

# PostgreSQL Aliases
alias pgstart='pg_ctl -D /usr/local/var/postgres -l logfile start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# Misc Aliases
alias findn='find . -name'
alias line_count='xargs wc -l | sort -n -r'
alias v='mvim .'

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ →\ \1/'
}

export PS1='@\h \[\e[1;31m\]\W\[\e[1;33m\]$(parse_git_branch)\[\e[0;39m\]> '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
export SSL_CERT_FILE=/usr/local/etc/openssl/cacert.pem
PATH=$HOME/.rbenv/bin:.bundle/binstubs:/usr/local/heroku/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:/opt/sm/bin:/opt/sm/pkg/active/bin:/opt/sm/pkg/active/sbin:/Users/sean/.ec2/bin:/usr/local/mysql/bin:/Applications/Postgres.app/Contents/MacOS/bin

export RBENV_ROOT=~/.rbenv
eval "$(rbenv init -)"
export EDITOR=mvim

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
# export PATH

# [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

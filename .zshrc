## History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# activate bash-style comments on the command line
setopt interactivecomments

# Set window title to command just before running it.
preexec() { printf "\x1b]0;%s\x07" "$1"; }

# Set window title to current working directory after returning from a command.
precmd() { printf "\x1b]0;%s\x07" "$PWD"; }

alias be='bundle exec'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long' # detailed list view
alias cat='bat'
alias ping='prettyping --nolegend'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias top="sudo htop" # alias top and fix high sierra bug

# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

## add bin/ and $HOME/bin to PATH
export PATH=bin:$HOME/bin:$PATH

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

eval "$(/opt/homebrew/bin/brew shellenv)"

## setup nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## setup rbenv
export PATH=~/.rbenv/shims:$PATH
eval "$(rbenv init -)"

# Function to login to AWS SSO and set the profile
awslogin() {
  profile=$1
  
  if [[ -z "$profile" ]]; then
    # Get available profiles
    local -a profiles
    [[ -f ~/.aws/config ]] && profiles=($(grep '^\[profile' ~/.aws/config | sed -e 's/\[profile \(.*\)\]/\1/'))
    [[ -f ~/.aws/config ]] && grep -q '^\[default\]' ~/.aws/config && profiles+=("default")
    
    if [[ ${#profiles[@]} -eq 0 ]]; then
      echo "No AWS profiles found in ~/.aws/config"
      return 1
    fi
    
    # Display menu for profile selection
    echo "Select an AWS profile:"
    select profile in "${profiles[@]}"; do
      if [[ -n "$profile" ]]; then
        break
      else
        echo "Invalid selection. Please try again."
      fi
    done
  fi
  
  # Login with the selected or provided profile
  aws sso login --profile $profile
  export AWS_PROFILE=$profile
  echo "AWS profile set to $profile"
}

# Simple autocomplete for AWS profiles
_aws_profiles() {
  local -a profiles
  [[ -f ~/.aws/config ]] && profiles=($(grep '^\[profile' ~/.aws/config | sed -e 's/\[profile \(.*\)\]/\1/'))
  [[ -f ~/.aws/config ]] && grep -q '^\[default\]' ~/.aws/config && profiles+=("default")
  compadd -a profiles
}

# Register the completion function
compdef _aws_profiles awslogin

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

eval "$(starship init zsh)"

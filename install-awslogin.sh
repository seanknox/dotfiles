#!/bin/zsh

# This script appends AWS profile setup to ~/.zshrc

cat << 'EOF' >> ~/.zshrc

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
EOF


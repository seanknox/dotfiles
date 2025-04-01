#!/bin/zsh

# This script appends AWS profile setup to ~/.zshrc

# cat << 'EOF' >> ~/.zshrc

# Function to login to AWS SSO and set the profile
awslogin() {
  profile=$1
  
  if [[ -z "$profile" ]]; then
    # Get available profiles
    local -a profiles
    local -a display_profiles
    [[ -f ~/.aws/config ]] && profiles=($(grep '^\[profile' ~/.aws/config | sed -e 's/\[profile \(.*\)\]/\1/'))
    [[ -f ~/.aws/config ]] && grep -q '^\[default\]' ~/.aws/config && profiles+=("default")
    
    if [[ ${#profiles[@]} -eq 0 ]]; then
      echo "No AWS profiles found in ~/.aws/config"
      return 1
    fi
    
    # Create display names with account numbers
    for p in "${profiles[@]}"; do
      # Get the account ID associated with the profile
      local account_id=""
      if [[ "$p" == "default" ]]; then
        account_id=$(\grep -A 10 '^\[default\]' ~/.aws/config | \grep 'sso_account_id' | head -1 | awk '{print $3}')
      else
        account_id=$(\grep -A 10 '^\[profile '"$p"'\]' ~/.aws/config | \grep 'sso_account_id' | head -1 | awk '{print $3}')
      fi
      
      if [[ -n "$account_id" ]]; then
        display_profiles+=("$p ($account_id)")
      else
        display_profiles+=("$p")
      fi
    done
    
    # Display menu for profile selection
    echo "Select an AWS profile:"
    select display_profile in "${display_profiles[@]}"; do
      if [[ -n "$display_profile" ]]; then
        # Extract just the profile name without the account ID
        profile=$(echo "$display_profile" | sed -e 's/ (.*)$//')
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
# EOF


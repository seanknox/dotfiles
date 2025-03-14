{ config, pkgs, username ? (builtins.getEnv "USER"), ... }:

{
  # System-wide settings
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };
    
    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
    };
    
    # Global settings
    NSGlobalDomain = {
      # Disable smart quotes and dashes
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      
      # Keyboard settings
      InitialKeyRepeat = 15;
      KeyRepeat = 1;
      ApplePressAndHoldEnabled = false;
      AppleKeyboardUIMode = 3;
      
      # Disable auto-correct
      NSAutomaticSpellingCorrectionEnabled = false;
      
      # Show all file extensions
      AppleShowAllExtensions = true;
    };
  };
  
  # System activation scripts
  system.activationScripts.extraActivation.text = ''
    # Show Library folder
    chflags nohidden ~/Library
    
    # Never go into computer sleep mode
    sudo systemsetup -setcomputersleep Off > /dev/null
    
    # Disable hibernation (speeds up entering sleep mode)
    sudo pmset -a hibernatemode 0
    
    # Increase sound quality for Bluetooth headphones/headsets
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
    
    # Empty Trash securely by default
    defaults write com.apple.finder EmptyTrashSecurely -bool true
    
    # Show path bar in Finder
    defaults write com.apple.finder ShowPathbar -bool true
    
    # Expand File Info panes
    defaults write com.apple.finder FXInfoPanesExpanded -dict \
      General -bool true \
      OpenWith -bool true \
      Privileges -bool true
    
    # Activity Monitor settings
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
    defaults write com.apple.ActivityMonitor IconType -int 5
    defaults write com.apple.ActivityMonitor ShowCategory -int 0
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0
    
    # Messages settings
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
  '';
  
  # Homebrew integration (for packages that can't be managed by Nix)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Remove all unmanaged packages
    };
    
    # Keep these packages managed by Homebrew for now
    # We'll migrate them to Nix in later phases
    casks = [
      "1password"
      "alfred"
      "docker"
      "dropbox"
      "google-chrome"
      "iterm2"
      "signal"
      "transmission"
      "protonvpn"
      "bartender"
      "cursor"
      "rectangle"
      "zoom"
      "warp"
      "arc"
      "whatsapp"
    ];
    
    # Homebrew fonts
    taps = [
      "homebrew/cask-fonts"
    ];
    
    caskArgs = {
      appdir = "~/Applications";
    };
  };
  
  # Enable fonts
  fonts.fontDir.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # This value determines the nix-darwin release that your configuration is
  # compatible with. This helps avoid breakage when a new nix-darwin release
  # introduces backwards incompatible changes.
  system.stateVersion = 4;
} 

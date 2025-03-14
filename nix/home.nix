{ config, pkgs, username ? (builtins.getEnv "USER"), homeDirectory ? "/Users/${builtins.getEnv "USER"}", ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  # These values will be provided by flake.nix or fall back to environment variables
  home.username = username;
  home.homeDirectory = homeDirectory;
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "23.11"; # Please read the comment before changing

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = with pkgs; [
    # CLI tools from your Brewfile
    jq
    go
    shellcheck
    wget
    bat
    htop
    fd
    
    # Additional useful tools
    ripgrep
    tree
    neofetch
  ];

  # Git configuration - ported from your existing .gitconfig
  programs.git = {
    enable = true;
    
    # User settings - these can be overridden with a machine-specific .gitconfig.local
    userName = "Sean Knox";
    userEmail = "knoxville@hey.com";
    
    # Aliases from your .gitconfig
    aliases = {
      co = "checkout";
      ci = "commit";
      br = "branch";
      hist = "log --pretty=format:'%Cgreen%h%Creset %Cblue%ad%Creset %C(magenta)%cn%Creset%C(yellow)%d%Creset%n        %s' --graph --date=local";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      rpo = "remote prune origin";
      unstage = "reset HEAD";
      pr = "pull --rebase";
      cp = "cherry-pick";
      pom = "push origin master";
      df = "diff";
      a = "add";
      g = "grep --break --heading --line-number";
      rp = "remote prune";
      gpc = "push --set-upstream origin $(git-branch-current 2>/dev/null)";
      aa = "add --all";
      ls = "ls-files";
      rbm = "!git fetch origin main && git rebase origin/main";
      st = "status";
      s = "status";
      rcm = "commit -c HEAD --reset-author";
      gr = "grep --break --heading --line-number";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)>%Creset' --abbrev-commit";
      wip = "!git add . && git commit -m 'wip'";
      amend = "!git add . && git commit --amend --no-edit";
      rim = "!git rebase -i origin/master";
      todo = "grep --heading --break --ignore-case -e 'TODO: *'";
      fixme = "grep --heading --break --ignore-case -e 'FIX: *' -e 'FIXME: *'";
    };
    
    # Additional git configuration from your .gitconfig
    extraConfig = {
      init.defaultBranch = "main";
      
      hub.protocol = "https";
      
      core = {
        autocrlf = "input";
        excludesfile = "${homeDirectory}/.gitignore";
      };
      
      difftool.prompt = false;
      
      grep.linenumber = true;
      
      branch = {
        autosetuprebase = "always";
        sort = "-committerdate";
      };
      
      pager.branch = false;
      
      color.ui = "auto";
      
      github.username = "seanknox";
      
      user.initials = "SK";
      
      column.ui = "auto";
      
      tag.sort = "version:refname";
      
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      
      help.autocorrect = "prompt";
      
      commit.verbose = true;
      
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      
      # Use conditional includes for machine-specific git config
      # This allows different git configs for different machines
      include.path = "~/.gitconfig.local";
    };
  };

  # ZSH configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    
    # History settings from your current .zshrc
    history = {
      size = 50000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };
    
    # Shell options
    initExtra = ''
      # Set window title to command just before running it.
      preexec() { printf "\x1b]0;%s\x07" "$1"; }
      
      # Set window title to current working directory after returning from a command.
      precmd() { printf "\x1b]0;%s\x07" "$PWD"; }
      
      # activate bash-style comments on the command line
      setopt interactivecomments
    '';
  };

  # FZF configuration (replacing your install-fzf.sh)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Create a basic configuration for other tools
  programs.bat.enable = true;
  
  # This section will be expanded in future phases
  # For now, we're just setting up the basics
} 

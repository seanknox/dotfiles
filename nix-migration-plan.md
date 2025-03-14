# Nix Migration Plan

This document outlines the phased approach to migrate from a Homebrew-based setup to Nix.

## Phase 1: Basic Nix Setup and Package Management

- [ ] Install Nix on Apple Silicon Mac
  - [ ] Run the official installer: `sh <(curl -L https://nixos.org/nix/install)`
  - [ ] Verify installation: `nix --version`
  - [ ] Enable flakes: Add `experimental-features = nix-command flakes` to `/etc/nix/nix.conf`

- [ ] Set up basic flake structure
  - [ ] Create a new Git repository for your Nix configuration
  - [ ] Initialize a basic flake.nix file
  - [ ] Add home-manager as an input

- [ ] Migrate core CLI tools from Homebrew to Nix
  - [ ] Identify essential CLI tools (git, jq, etc.)
  - [ ] Add them to your home-manager configuration
  - [ ] Test that they work correctly

- [ ] Create a basic home-manager configuration
  - [ ] Set up shell environment variables
  - [ ] Configure Git basics

## Phase 2: Shell Environment and Development Tools

- [ ] Configure zsh through home-manager
  - [ ] Migrate history settings
  - [ ] Set up key bindings
  - [ ] Configure prompt

- [ ] Set up development environments
  - [ ] Configure Node.js environment (replacing nvm)
  - [ ] Configure Ruby environment (replacing rbenv)
  - [ ] Set up Python environment (replacing pyenv)

- [ ] Migrate shell utilities
  - [ ] Set up fzf with home-manager
  - [ ] Configure z for directory jumping
  - [ ] Set up colorized ls (replacing colorls)

## Phase 3: Application Management

- [ ] Research Nix options for GUI applications
  - [ ] Identify which applications can be managed with Nix
  - [ ] Identify which need to remain with Homebrew

- [ ] Migrate compatible applications to Nix
  - [ ] Add applications to home-manager configuration
  - [ ] Test launching and functionality

- [ ] Set up application configurations
  - [ ] Configure iTerm2/terminal settings
  - [ ] Set up editor configurations

## Phase 4: macOS Configuration

- [ ] Set up nix-darwin
  - [ ] Add nix-darwin to your flake
  - [ ] Create basic configuration

- [ ] Migrate macOS settings
  - [ ] Convert keyboard settings (key repeat, etc.)
  - [ ] Configure system preferences
  - [ ] Set up Finder preferences

- [ ] Test full configuration
  - [ ] Apply to a clean macOS installation if possible
  - [ ] Verify all settings are applied correctly

## Phase 5: Cleanup and Documentation

- [ ] Remove Homebrew packages that have been migrated to Nix
  - [ ] Update Brewfile to remove migrated packages
  - [ ] Keep Homebrew only for packages that can't be migrated

- [ ] Document your Nix configuration
  - [ ] Add comments to your flake.nix and other configuration files
  - [ ] Create a README with setup instructions

- [ ] Create a backup/restore strategy
  - [ ] Document how to backup your Nix configuration
  - [ ] Test restoring from backup 

{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # Minimal configuration for testing
  home.stateVersion = "23.11";
  
  # No packages or complex configurations
} 

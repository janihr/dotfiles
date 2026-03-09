{ config, pkgs, ... }:

{
  
  home.username = "jarig";
  home.homeDirectory = "/home/jarig";
  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator

    stow
    bitwarden-desktop
  ];

  home.stateVersion = "25.11";
}

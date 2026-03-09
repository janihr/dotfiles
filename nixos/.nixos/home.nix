{ config, pkgs, ... }:

{
  
  home.username = "jarig";
  home.homeDirectory = "/home/jarig";
  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator

    stow
    thunderbird
    bitwarden-desktop
    signal-desktop
    nextcloud-client
  ];

  home.stateVersion = "25.11";
}

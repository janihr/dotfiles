{ config, pkgs, ... }:

{
  
  home.username = "jarig";
  home.homeDirectory = "/home/jarig";
  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # desktop
    gnome-tweaks
    gnomeExtensions.appindicator

    # programs
    stow
    thunderbird
    bitwarden-desktop
    signal-desktop
    nextcloud-client

    # dev programs
    uv
  ];

  home.stateVersion = "25.11";
}

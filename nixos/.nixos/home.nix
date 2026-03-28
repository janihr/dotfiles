{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    # inputs.dms.homeModules.niri
  ];
 
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
    niri

    # dev programs
    uv
    mpls # markdown lsp

    pkgs.gnomeExtensions.paperwm
  ];

  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    # niri = {
    #   enableKeybinds = true;   # Sets static preset keybinds
    #   enableSpawn = true;      # Auto-start DMS with niri, if enabled
    # };
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };


  home.stateVersion = "25.11";
}

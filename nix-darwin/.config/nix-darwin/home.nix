{ pkgs, username, ... }: {
  # Home Manager needs this to know who you are
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # This is where Teams goes to be "user-only"
  home.packages = with pkgs; [
    fastfetch
  ];

  # Required for Home Manager
  home.stateVersion = "24.05";
}

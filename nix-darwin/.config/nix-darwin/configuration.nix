{ pkgs, inputs, username, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  environment.systemPackages = with pkgs; [
    git
    helix
    tmux
    tree
    wezterm
    zellij
    rclone
  ];

  homebrew = {
    enable = true;
    casks = [
      "bitwarden"
      "itk-snap"
      "logseq"
      "microsoft-teams"
      "notunes"
      "hammerspoon"
      "google-chrome"
    ];
  };
}

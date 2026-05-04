{ pkgs, inputs, username, ... }: {

  # Auto upgrade nix package
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # allow unfree
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    helix
    tmux
    zellij
    git
    # fastfetch
    wezterm
  ];

  system.primaryUser = "${username}";
  users.users.${username} = {
      name = "${username}";
      home = "/Users/${username}";
  };
  # Use homebrew to install casks and Mac App Store apps
  homebrew = {
    enable = true;

    brews = [
    ];
    casks = [
      "aerospace"
      "microsoft-teams"
      "logseq"
    ];
  };


}

{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    fastfetch
    texlab
    (texlive.withPackages (ps: [
        ps.scheme-full
        ps.latexmk
    ]))
  ];

  targets.darwin.defaults = {
    # Disable "Open man Page" shortcut in Terminal
    "com.apple.Terminal" = {
      NSUserKeyEquivalents = {
        "Open man Page" = "\\0";
      };
    };
  };
}

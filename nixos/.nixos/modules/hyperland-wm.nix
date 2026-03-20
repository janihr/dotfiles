{pkgs, inputs, ...}:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  }; # enable Hyprland
  environment.systemPackages = with pkgs; [
    kitty # Hyperland uses kitty by default
    # ashell # out of the box Wayland status bar for Hyperland
    rofi
  ];
}

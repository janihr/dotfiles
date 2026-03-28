{pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    niri
    alacritty
    fuzzel
    xwayland-satellite
  ];
  programs.niri = {
    enable = true;
  };

}

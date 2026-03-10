# Nix-Darwin Configuration

# install nix for macOS
- install with the [official installer](https://nixos.org/download/)
- some helpful [link](https://nixcademy.com/posts/nix-on-macos/)

# setup config
- have git and GNU stow installed
- clone dotfile repo and link config with stow
  ```bash
  git clone git@github.com:janihr/dotfiles.git .dotfiles
  cd .dotfiles
  stow nix-darwin
  ```
- activate configuration
  ```bash
  sudo nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix-darwin#simple
  ```

# change system
- edit ~/.config/nix-darwin/flake.nix
- rebuild
  ```bash
  sudo darwin-rebuild switch --flake ~/.config/nix-darwin#simple

  ```

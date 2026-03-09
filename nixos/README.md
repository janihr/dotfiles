# NixOS configuration

# install
- install editor, git and GNU stow via the default configuration.nix
- clone dotfiles repo to .dotfiles
  ```bash
  git clone git@github.com:janihr/dotfiles.git .dotfiles
  ```
- link nixos config from this repo to `~/.nixos`
  ```bash
  cd .dotfiles && stow nixos
  ```
- link nixos config to /etc
  ```bash
  cd /etc/
  sudo mv nixos nixos.bak
  sudo ln -s ~/.nixos nixos
  ```
- install via
  ```bash
  sudo nixos-rebuild switch
  ```


{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:

  let

    identity = import ./identity.nix;

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        username = identity.username;
        inherit inputs;
      };
      modules = [

        ./configuration.nix

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;     # Uses the flake's nixpkgs
          home-manager.useUserPackages = true;    # Installs to user profile
          home-manager.extraSpecialArgs = { inherit (identity) username; };
          home-manager.users.${identity.username} = import ./home.nix;
        }

      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}

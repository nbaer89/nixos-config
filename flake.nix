{
  description = "NixOS remote development environment boilerplate";

  inputs = {
    # CUSTOMIZE: Pin to a stable release if preferred, e.g. nixos-25.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    # CUSTOMIZE: Change this if your host is ARM, e.g. aarch64-linux.
    system = "x86_64-linux";

    # CUSTOMIZE: Your login user.
    username = "nathan";
  in {
    nixosConfigurations.devbox = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit username;
      };

      modules = [
        ./hosts/devbox/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username; };
          home-manager.users.${username} = import ./users/nathan/home.nix;
        }
      ];
    };
  };
}

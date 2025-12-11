{
  description = "Flake of a cool screenshot utility for Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
          packages = rec {
            default = nixpkgs.legacyPackages.${system}.callPackage ./. { };
          };
      }
    );
}

{
  description = "My talks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    laas-beamer-theme = {
      url = "git+https://gitlab.laas.fr/gsaurel/laas-beamer-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ laas-beamer-theme, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        {
          pkgs,
          self',
          system,
          ...
        }:
        {
          checks = {
            packages = self'.packages.default;
          };
          packages.default = pkgs.callPackage ./default.nix {
            laas-beamer-theme = laas-beamer-theme.packages.${system}.default;
          };
          devShells.default = pkgs.mkShell {
            inputsFrom = [ self'.packages.default ];
            packages = [
              pkgs.pdfpc
              pkgs.watchexec
            ];
          };
        };
    };
}

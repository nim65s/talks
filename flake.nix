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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];
      systems = [ "x86_64-linux" ];
      perSystem =
        {
          config,
          pkgs,
          self',
          system,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [ config.treefmt.build.wrapper ];
            inputsFrom = [ self'.packages.default ];
            packages = [
              pkgs.pdfpc
              pkgs.watchexec
            ];
          };
          packages.default = pkgs.callPackage ./default.nix {
            laas-beamer-theme = inputs.laas-beamer-theme.packages.${system}.default;
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              biome.enable = true;
              deadnix.enable = true;
              nixfmt-rfc-style.enable = true;
              ruff = {
                check = true;
                format = true;
              };
            };
          };
        };
    };
}

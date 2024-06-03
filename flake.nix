{
  description = "My talks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    laas-beamer-theme = {
      url = "git+https://gitlab.laas.fr/gsaurel/laas-beamer-theme";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      laas-beamer-theme,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        talks = pkgs.callPackage ./default.nix {
          laas-beamer-theme = laas-beamer-theme.packages.${system}.default;
        };
      in
      {
        packages.default = talks;
        devShells.default = pkgs.mkShell {
          inputsFrom = [ talks ];
          packages = [
            pkgs.pdfpc
            pkgs.watchexec
          ];
        };
      }
    );
}

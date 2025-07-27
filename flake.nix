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
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
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
          inputs',
          lib,
          pkgs,
          self',
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (_: _: {
                inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
                laas-beamer-theme = inputs'.laas-beamer-theme.packages.default;
                nim65s-talks = pkgs.callPackage ./pkgs { };
                nim65s-talks-css = pkgs.callPackage ./pkgs/css.nix { };
                nim65s-talks-html = pkgs.callPackage ./pkgs/html.nix { };
                nim65s-talks-index = pkgs.callPackage ./pkgs/index.nix { };
                nim65s-talks-pdfs = pkgs.callPackage ./pkgs/pdfs.nix { };
              })
            ];
          };
          devShells = {
            default = pkgs.mkShell {
              nativeBuildInputs = [ config.treefmt.build.wrapper ];
              inputsFrom = [
                self'.packages.nim65s-talks-css
                self'.packages.nim65s-talks-index
                self'.packages.nim65s-talks-pdfs
              ];
              env = {
                UV_NO_SYNC = "1";
                UV_PYTHON = lib.getExe' self'.packages.editableVirtualenv "python";
                UV_PYTHON_DOWNLOADS = "never";
              };
              packages = [
                pkgs.pdfpc
                pkgs.watchexec
                pkgs.yarn-berry_4.yarn-berry-fetcher
                self'.packages.editableVirtualenv
              ];
              shellHook = ''
                unset PYTHONPATH
                export REPO_ROOT=$(git rev-parse --show-toplevel)
              '';
            };
            deploy = pkgs.mkShell {
              packages = [
                pkgs.rsync
              ];
            };
          };
          packages = {
            inherit (pkgs)
              nim65s-talks
              nim65s-talks-css
              nim65s-talks-html
              nim65s-talks-index
              nim65s-talks-pdfs
              ;
            inherit (pkgs.nim65s-talks-index.passthru) editableVirtualenv virtualenv;
            default = pkgs.nim65s-talks;
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              biome.enable = true;
              deadnix.enable = true;
              nixfmt.enable = true;
              ruff = {
                check = true;
                format = true;
              };
            };
          };
        };
    };
}

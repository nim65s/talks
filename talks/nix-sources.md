---
title: "Nix: maîtrisez les sources de vos paquets"
subtitle: Capitole du Libre 2024
theme: laas
date: 2024-11-15
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
header-includes:
- \titlegraphic{\includegraphics[height=1.5cm]{media/cdl24.pdf}}
urls:
- name: Recording
  url: https://videos.capitoledulibre.org/w/mbsyVFXQRzWJpXj4doRAvA
- name: Capitole du Libre 2024
  url: https://cfp.capitoledulibre.org/cdl-2024/talk/VB7PBH/
---

## Cette présentation

### Disponible à

\centering

[`https://homepages.laas.fr/gsaurel/
nix-sources.pdf`](https://homepages.laas.fr/gsaurel/nix-sources.pdf)

### Source

\centering

[`https://gitlab.laas.fr/gsaurel/talks :
nix-sources.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/nix-sources.md)

### Sous license

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

# Prérequis

## Paquet

Dans le monde UNIX:

- un logiciel

. . .

- sa configuration
- sa documentation
- son installation
- ses dépendances

## Nix

C’est (entre autres) un gestionnaire de paquets

. . .

 

> The Purely Functional Software Deployment Model

\hfill --- Eelco Dolstra, PhD Thesis, 2006

# Pourquoi

## Pour installer des logiciels

- firefox
- vlc
- libreoffice

. . .

- linux
- systemd

. . .

- gcc
- pytorch
- nextcloud
- angular
- nerdfonts

## Pour vérifier sa chaîne d’approvisionnement

- Quelle version de de quel logiciel ?

. . .

- Récupérée depuis quelle source ?

. . .

- Compilée de quelle manière ?

. . .

- Avec quelles dépendances ?

## Pour modifier ce que vous voulez

- Utiliser une version particulière
- Ajouter des patchs
- Modifier certains paramètres de compilation

. . .

- Ajouter des modules noyau
- Activer des services systemd


## Modulaire, Versionné & Reproductible

- configuration as code
- rollbacks
- sandbox

. . .

pour un paquet, ou un environnement, ou un OS

# Nixpkgs

## Un monorépo

- <https://github.com/NixOS/nixpkgs>
- repology: 100k paquets

. . .

- ajoutez le votre: PR

## NixOS stable & unstable

- une rolling release: `nixos-unstable`
- une version stable tous les 6 mois: `nixos-24.11`

. . .

- `master`

## custom forks / branches

- bring your own `master`

## custom PR

`applyPatches` !

# NUR

## Encore plus de paquets

- 264 dépôts indépendants
- 4852 paquets en plus

## Et les votres !

<https://github.com/nix-community/NUR/blob/master/README.md#how-to-add-your-own-repository>

# Flakes

## Chaque paquet à sa source

- un dépôt git avec un `flake.nix` (et un `flake.lock`)

. . .

### outputs

- paquets
- applications
- devShells
- Modules NixOS
- tests
- templates
- overlays

## Flake inputs

- autres flakes:
    - `nixpkgs/nixos-unstable`
    - `github:stack-of-tasks/pinocchio`
- urls classiques
    - `https://github.com/NixOS/nixpkgs/pull/354231.patch`
    - `


## Dépôts de flakes

- Github / Gitlab / …
- <https://flakehub.com/>
- <https://flakestry.dev/>
- <https://github.com/cafkafk/rime>

# Questions ?

## Merci :)

### Contact

![Guilhem Saurel / `@nim65s`](media/NimNB_carre.jpg){width=1cm}

### Slides

[`https://homepages.laas.fr/gsaurel/
nix-sources.pdf`](https://homepages.laas.fr/gsaurel/nix-sources.pdf)

### Voir aussi

- "Home-manager", CDL 2023
- "Nix et NixOS: fonctionnement technique", demain 11:30, A202
- "NixOS embarqué dans la stratosphère", demain 15:00, B00

# Extra: applyPatches

## flake.nix

\fontsize{8}{9}
\selectfont

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pin = {
      url = "https://github.com/NixOS/nixpkgs/pull/354231.patch";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    perSystem = { pkgs, system, ...  }: {
      _module.args.pkgs = import ./patched-nixpkgs.nix {
        inherit nixpkgs system;
        patches = [ inputs.pin ];
      };
      packages.default = pkgs.python3.withPackages (p: [p.pinocchio]);
    };
  };
}
```

## patched-nixpkgs.nix

```nix
{ nixpkgs, patches, system, ...  }:
let
  super = import nixpkgs { inherit system; };
in
import (super.applyPatches {
  inherit patches;
  name = "patched nixpkgs";
  src = nixpkgs;
}) { inherit system; }
```

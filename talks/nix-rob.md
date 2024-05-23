---
title: Nix & NixOS
subtitle: pour la robotique
theme: laas
date: 2024-05-23
author: Guilhem Saurel
mainfont: Source Serif 4
monofont: Source Code Pro
talk-urls:
- name: "2RM: École Technologique 2024"
  url: https://wiki.2rm.cnrs.fr/EcoleTechno2024
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
nix-rob.pdf`](https://homepages.laas.fr/gsaurel/talks/nix-rob.pdf)

[`https://gitlab.laas.fr/gsaurel/talks :
nix-rob.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/nix-rob.md)

### Under License

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

# Introduction

## Résumé des épisodes précédents

- robotpkg

. . .

- cmake-wheel

. . .

- PID

## Repology

![](media/repology-24.png)

# Cahier des charges

## Installer des paquets

- source
- binaires

. . .

- cache

## Reproducibilité des paquets

Mêmes sources + recette => mêmes résultats

. . .

- OS (eg. macos / linux)
- CPU (eg. x86_64 / arm64)
- Compilateur (eg. gcc / clang)
- Environnement
- Options automatiques

=> Isolation

## Dépendences

L’Enfer.

. . .

- versions
- ld
- python
- etc.

## Portée

- Paquets système
- Environnements de travail

. . .

droits

## Hacking

- Et si on changeait l’implémentation de BLAS ?
- Et si on utilisait on recompilait tout avec LLVM ?
- Et si on passait à `-march=native` ?
- Et si on désactivait les mitigations downfall ?
- Et si on modifiait un flag du noyau ?

## L’intégration continue & l’outillage

Ref. Own your CI with Nix. FOSDEM, @thufschmitt24

# La solution

## Eelco Dolstra PhD

Ref. The purely functional software deployment model. PhD, @edolstra06

## Domain-Specific Language

```nix
stdenv.mkDerivation rec {
 pname = "hello";
 version = "2.12.1";

 src = fetchurl {
  url = "mirror://gnu/hello/hello-${version}.tar.gz";
  hash = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2…=";
 };

 doCheck = true;
})
```

## Dérivations

```
nix-repl> pkgs.hello
«derivation /nix/store/img71klf2wzx867q5ldhf0zqc3wl0mxk-hello-2.12.1.drv»

nix-repl> "${pkgs.hello}"
"/nix/store/bw9z0jxp5qcm7jfp4vr6ci9qynjyaaip-hello-2.12.1"
```

## Paquets

```bash
$ tree  /nix/store/bw9…-hello-2.12.1
bw9…-hello-2.12.1/
├── bin/
│   └── hello*
└── share/
    ├── info/
    │   └── hello.info
    ├── locale/
    │   └── […]
    └── man/
        └── man1/
            └── hello.1.gz
```

## Liens dynamiques

```bash
$ ldd /nix/store/bw9…-hello-2.12.1/bin/hello
linux-vdso.so.1 (0x00007fab657f1000)
libc.so.6 => /nix/store/35p…-glibc-2.39-5/lib/libc.so.6 (0x00007fab655fe000)
/nix/store/35p…-glibc-2.39-5/lib/ld-linux-x86-64.so.2 (0x00007fab657f3000)
```

## Flakes

- dépôt git + flake.nix
- entrées: autres flakes
- sorties:
    - paquets
    - applications
    - tests
    - dev shells
    - NixOS configurations

# NixOS

## Wishlist

Ref. ROS2 deployment with docker and balenaos. ROSConFr, @xouillet23:


> Deploying on Robot/embedded device whishlist:
>
> - Easy updates/rollback
> - Same code/binary on all devices
> - No user interaction installation

## Générations

Mise à jour / rollbacks

# Robotique

## Open Dynamic Robot Initiative

![solo](media/solo.png)

## ROS

![](media/nix-roscon.png)

<https://github.com/lopsided98/nix-ros-overlay>

# Communauté: projets

## Home-Manager

"dotfiles" déclaratifs

## disko

```nix
disko.devices.disk.my-disk = {
  device = "/dev/sda";
  type = "disk";
  content = {
    type = "gpt";
    partitions = {
      ESP = {
        type = "EF00";
        size = "500M";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
```

## disko (suite)

```nix
disko.devices.disk.my-disk = {
  device = "/dev/sda";
  type = "disk";
  content = {
    type = "gpt";
    partitions = {
      ESP = { ... };
      root = {
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
  };
};
```

## nixos-anywhere

Installation automatique

## sops-nix

Gestion des secrets par utilisateur et par machine

# Communauté: entreprises

## Principales contributrices

- Determinate Systems
- Flox
- Tweag / Modus Create
- Numtide
- Cachix
- Hercules-CI

## Controversées

- Anduril

# Communauté: humains

## PFH

…

# Questions ?

## Questions ?

### Links

- [`https://homepages.laas.fr/gsaurel/talks/
home-manager.pdf`](https://homepages.laas.fr/gsaurel/talks/home-manager.pdf)
[(enregistrement)](https://www.youtube.com/watch?v=dp-9jkSsWWs)
- [`https://homepages.laas.fr/gsaurel/talks/
nix-rob.pdf`](https://homepages.laas.fr/gsaurel/talks/nix-rob.pdf)

### References

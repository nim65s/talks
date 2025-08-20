---
title: Nix, Nixpkgs & NixOS
theme: laas
date: 2024-06-14
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/
nix.pdf`](https://homepages.laas.fr/gsaurel/nix.pdf)

[`https://gitlab.laas.fr/gsaurel/talks :
nix.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/nix.md)

### Under License

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

### Discussions

[#nix:laas.fr](https://matrix.to/#/#nix:laas.fr)

# Introduction

## Résumé des épisodes précédents

- Linters:
    - faciliter l’écriture des sources
    - standardiser la forme des sources

. . .

- git & CI:
    - gérer le passé, le présent, et l’avenir des sources
    - faciliter les modifications des sources

. . .

- Build: transformer les sources en fichiers utilisables

. . .

- Packaging: mettre ces fichiers au bon endroit
    - dépendances
    - distributions

# Cahier des charges

## Installer des paquets

- source
- binaires

. . .

- cache

## Reproducibilité

Mêmes sources + recette => mêmes résultats

. . .

- OS (eg. macos / linux)
- CPU (eg. x86_64 / arm64)
- Compilateur (eg. gcc / clang)
- Environnement
- Options automatiques

=> Isolation

. . .

### Gains

- Si ça a été compilé une fois, pas besoin de recompiler
- Si ça marche sur un ordinateur, ça marche sur un autre

### Limites

- dépendances: nombre de paquets déjà disponibles

## Repology

![](media/repology-24-06.png)

## L’intégration continue & l’outillage

Ref. Own your CI with Nix. FOSDEM, @thufschmitt24

# La solution

## Eelco Dolstra PhD

Ref. The purely functional software deployment model. PhD, @edolstra06

## Une solution déclarative

### Impératif

> lancer la commande:
>
> `echo 'enable = true' >> /etc/toto.conf`

### Déclaratif

> Définir que `/etc/toto.conf` soit `enable = true`

## Une solution fonctionnelle & lazy

Simplement modifier n’importe quel paramètre

## Une solution composable

- projet
- user
- OS

## Une solution immutable

`/nix/store` est read-only

## Une solution sans effets de bord

«Réaliser» un paquet n’agit que sur ce paquet

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

nix-repl> pkgs.hello.outPath
"/nix/store/bw9z0jxp5qcm7jfp4vr6ci9qynjyaaip-hello-2.12.1"
```

## Paquets

```bash
$ tree /nix/store/bw9z0jxp…-hello-2.12.1
bw9z0jxp…-hello-2.12.1/
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

## Dépendances

```bash
$ ldd /nix/store/bw9z0jxp…-hello-2.12.1/bin/hello
linux-vdso.so.1 (0x00007fab657f1000)
libc.so.6 => /nix/store/35p…-glibc-2.39-5/lib/libc.so.6 (0x00007fab655fe000)
/nix/store/35p…-glibc-2.39-5/lib/ld-linux-x86-64.so.2 (0x00007fab657f3000)
```

## Nixpkgs

- 100k paquets
- 7k contributeurs
- 3k mainteneurs
- 640k commits
- 20 ans

## Flakes

- dépôt git + flake.nix
- entrées: autres flakes
- sorties:
    - paquets
    - applications
    - tests
    - dev shells
    - NixOS configurations
    - Home-Manager configurations

## Flake example: `package.nix`

```nix
{ hello }:
hello.overrideAttrs (_: {
  postPatch = ''
    substituteInPlace src/hello.c \
      --replace world LAAS
  '';
  doCheck = false;
})
```

## Flake example: `flake.nix`

```nix
{
  description = "hello LAAS";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      hello-laas = pkgs.callPackage ./package.nix {};
    in
    {
      packages.${system}.default = hello-laas;
      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ hello-laas ];
      };
    };
}
```

# NixOS

## Déclaration

```nix
{
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "loon";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr-bepo";
  users.users.gsaurel = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Guilhem Saurel";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  environment.systemPackages = [ pkgs.git pkgs.vim ];
  services.openssh.enable = true;
}
```

## Générations

- Mise à jour atomiques

. . .

- Rollbacks atomiques

. . .

- Garbage collector

# Communauté: projets

## Home-Manager

```nix
home = {
  packages = [ … ];
  home.file = {
    ".config/dfc/dfcrc".source =
        ./.config/dfc/dfcrc;
  };
  sessionVariables.PAGER = "vim -c PAGER -";
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };
  programs.git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      userName = "Guilhem Saurel";
      userEmail = "guilhem.saurel@laas.fr";
  };
}
```

## nix-direnv

```
$ echo "use flake" >> .envrc
$ direnv allow
```

<https://github.com/nix-community/nix-direnv>

## cachix

Cache binaire

<https://www.cachix.org/>

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

## nixos-anywhere

Installation automatique

<https://github.com/nix-community/nixos-anywhere>

## sops-nix

Gestion des secrets par utilisateur et par machine

<https://github.com/Mic92/sops-nix>

## buildbot-nix

Framework CI/CD

<https://github.com/Mic92/sops-nix>

## treefmt-nix

Formatte tous les langages

<https://github.com/numtide/treefmt-nix>

## Github actions:

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: DeterminateSystems/nix-installer-action@v12
  - uses: DeterminateSystems/magic-nix-cache-action@v7
  - run: nix flake check
  - run: nix build
```

## NUR

Fédération de dépôts personnels

<https://nur.nix-community.org/>

## Environnements de développement

- flake & `devShells`
- `shell.nix`

. . .

- [cachix/devenv](https://github.com/cachix/devenv)
- [numtide/devshell](https://github.com/numtide/devshell)
- [jetify-com/devbox](https://github.com/jetify-com/devbox)
- [flox/flox](https://github.com/flox/flox)

. . .

- direnv

## NixOS hardware

Collection de modules pour différents devices

<https://github.com/NixOS/nixos-hardware/>

## NixOS Configuration

- <https://mynixos.com/>
- <https://github.com/snowfallorg/nixos-conf-editor>
- <https://github.com/snowfallorg/nix-software-center>

## Autres utilisations

- nixos
- VMs
- containers
- isos
- macos
- freebsd
- android
- projets par langage

# Communauté: Communication

## Github

- <https://github.com/NixOS/>
- <https://github.com/nix-community/>

## Discourse

<https://discourse.nixos.org/>

## Matrix

[#space:nixos.org](https://matrix.to/#/#space:nixos.org)

## Documentation

### Officielle

- <https://nix.dev/>
- <https://wiki.nixos.org/>
- <https://nixos.org/learn/>: Nix{,pkgs,OS} manual
- <https://nixos.org/guides/nix-pills/>

### Communauté

- <https://zero-to-nix.com/>
- <https://nixos-and-flakes.thiscute.world/>

## Recherche

- <https://search.nixos.org/>
- <https://home-manager-options.extranix.com/>
- <https://noogle.dev/>
- <https://code.tvl.fyi/about/nix/nix-1p>

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

# Communauté: projets connexes

## Guix

Ref. Functional package management with guix. arXiv, @guix13

<https://guix.gnu.org/>

## Tvix

Nouvelle implémentation, en Rust

<https://tvix.dev/>

## Lix

Fork de NixCPP

<https://lix.systems/>

## Aux

Un alternative à l’écosystème Nix

<https://aux.computer/en/>

# Communauté: humains

## PFH

…

# Attention

## Learning curve

Apprendre un nouveau langage difficile

## Isolation

Toute la chaîne doit être connue

## cache de compilation

- ccache
- sccache

## Gouvernance

Explosion de la taille de la communauté

- Assemblée Constitutante
- <https://nixpkgs.zulipchat.com/>

# Conclusion

## Conclusion

- De nouveaux paradigmes
- Un large pannel d’applications pratiques
- Des tas de problèmes résolus
- Beaucoup d’activités et d’engouements

=> Une aventure qui vaut le coup, allez-y !

. . .

Mais prenez votre temps.

# Questions ?

## Questions ?

### Links

- [`https://homepages.laas.fr/gsaurel/
home-manager.pdf`](https://homepages.laas.fr/gsaurel/home-manager.pdf)
[(enregistrement)](https://www.youtube.com/watch?v=dp-9jkSsWWs)
- [`https://homepages.laas.fr/gsaurel/
nix-rob.pdf`](https://homepages.laas.fr/gsaurel/nix-rob.pdf)

### References

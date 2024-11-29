---
title: Rust
subtitle: ANF 2024
theme: laas
date: 2024-11-29
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
rust-anf.pdf`](https://homepages.laas.fr/gsaurel/talks/rust-anf.pdf)

### Under License

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

## This presentation (continued)

### Source

\centering

[`https://gitlab.laas.fr/gsaurel/talks :
rust-anf.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/rust-anf.md)

### Discussions & Companion project

\centering

\url{https://github.com/nim65s/RobotS}

# Intro

## `rust-toolchain.toml`

```toml
[toolchain]
channel = "nightly-2024-11-28"
targets = [
    "riscv32im-unknown-none-elf"
    "wasm32-unknown-unknown"
]
components = [
    "llvm-tools-preview"
    "rust-src"
]
```

## Objectifs

- rust embarqué (embassy)
- web fullstack (leptos)

. . .

<https://github.com/nim65s/RobotS>

# Rust Embedded

## Fearless concurrency, interoperable, portable

![Rust Embedded](media/rust-embedded.png){width=50%}

## Bare

- lire la datasheet
- registre de configuration des GPIO
- registre de données des GPIO

. . .

arithmétique booléenne + arithméthique de pointeurs

. . .

unsafe

## Ecosystème: Périphériques internes

- PAC: Peripheral Access Crates
    - svd2rust
    - safe
    - impose que les périphériques internes ne soient pas partagés
    - zero-cost abstraction

. . .

- HAL: Hardware Abstraction Layers
    - haut niveau
    - impose que les périphériques internes soient correctement configurés pour être utilisables
    - plus besoin de lire la datasheet

## Ecosystème: Périphériques externes

- Driver
    - impose que les périphériques internes ne soient pas partagés
    - impose que les périphériques internes soient correctement configurés pour être utilisables

. . .

- Embedded-HAL
    - traits génériques pour les périphériques
    - implémentés par les HAL
    - utilisés par les Drivers

## Frameworks

- [RTIC](https://rtic.rs/)
- [Embassy](https://embassy.dev/)

# Web

## Leptos

![Fast full-stack web apps in Rust](media/leptos.png){width=80%}

## References

- <https://doc.rust-lang.org/rust-by-example/>
- <https://doc.rust-lang.org/book/>

- <https://docs.rust-embedded.org/book/>
- <https://embassy.dev/book/>
- <https://book.leptos.dev/>

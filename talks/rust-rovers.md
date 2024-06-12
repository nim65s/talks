---
title: Rust RoverS
subtitle: 2RM, École Technologique 2023
theme: laas
date: 2023-05-15
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
talk-urls:
- name: "2RM: École Technologique 2023"
  url: https://wiki.2rm.cnrs.fr/EcoleTechno2023
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
rust-rovers.pdf`](https://homepages.laas.fr/gsaurel/talks/rust-rovers.pdf)

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
rust-rovers.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/rust-rovers.md)

### Discussions & Companion Project

\centering

\url{https://github.com/nim65s/RobotS}

# Présentations

## Moi

![IR en robotique humanoïde](media/robots.jpg){width=80%}

# Rovers

## Contexte

<https://www.youtube.com/watch?v=1-TDT7pREOg>

# Rust

## Performant, Fiable, Productif

![Rust](media/rust.png){width=50%}

## Structures de données

```rust
struct Pose {
    x: f64,
    y: f64,
}

enum Mode {
    Idle,
    Move(Pose, f64),
}

struct Robot {
    name: String,
    pose: Pose,
    mode: Mode,
}
```

## Traits

```rust
pub trait SetSpeed {
    fn set_speed(&mut self, tgt: f64) -> Result<()>;
}

impl SetSpeed for Robot {
    fn set_speed(&mut self, tgt: f64) -> Result<()>{
        match self.mode {
            Mode::Idle => Err(Error::IsIdle),
            Mode::Move(pose, _) = {
                self.mode = Mode::Move(pose, tgt);
                Ok(())
            }
        }
    }
}
```

## Async

```rust
#[tokio::main]
async fn main() -> Result<()> {
    let port = 1234;
    tokio::spawn(async move {
        serve(port).await;
    });

    let mut client = client::connect(port).await?;
    client.set("hello", "world").await?;

    let result = client.get("hello").await?;
    println!("got {result:?}");

    Ok(())
}
```

## Channels

```rust
#[tokio::main]
async fn main() {
    let (tx, mut rx) = mpsc::channel(32);

    tokio::spawn(async move {
        tx.send("sending from first handle").await;
    });

    while let Some(message) = rx.recv().await {
        println!("GOT = {}", message);
    }
}
```

# Rust Embedded

## Fearless concurrency, interoperable, portable

![Rust Embedded](media/rust-embedded.png){width=50%}

## Ecosystème

- PAC: Peripheral Access Crates
- HAL: Hardware Abstraction Layers

Les sont implémentés avec les traits fournis par `embedded-hal`, et fonctionnent partout !

## Frameworks

- RTIC
- Embassy

# Web

## Leptos

![Fast web apps in Rust](media/leptos.png){width=80%}

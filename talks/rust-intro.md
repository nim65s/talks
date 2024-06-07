---
title: Rust
subtitle: Bases et examples
theme: laas
date: 2024-06-06
author: Guilhem Saurel
mainfont: Source Serif 4
monofont: Source Code Pro
talk-urls:
- name: Enregistrement
  url: https://peertube.laas.fr/w/1oVRC3dqz72m62DCziqKBf
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
rust-intro.pdf`](https://homepages.laas.fr/gsaurel/talks/rust-intro.pdf)

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
rust-intro.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/rust-intro.md)

### Discussions & Companion project

\centering

\url{https://github.com/nim65s/RobotS}

# Introduction

## Goals

1. introduction
2. nice features in a langage
3. nice features in the tooling
4. scope
5. limitations

## Performance, Reliability, Productivity

![Rust](media/rust.png){width=50%}

# Base Tooling

## Rustup

![<https://rustup.rs/>](media/rustup.png)

## Cargo

```sh
$ mkdir first
$ cd first
$ cargo init
    Creating binary (application) package
$ cargo run
   Compiling first v0.1.0 (/root/first)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.13s
     Running `target/debug/first`
Hello, world!
```

# Language

## Hello World

```sh
$ cat src/main.rs
```

```rust
fn main() {
    println!("Hello, world!");
}
```

## Mutability

```rust
let x = 5;
let mut y = 6;
```

. . .

```rust
x += 1; // Error
y += 1; // Ok
```

## Compiler Errors

```rust
Compiling first v0.1.0 (/tmp/first)
error[E0384]: cannot assign twice to immutable variable `x`
  --> src/main.rs:27:5
   |
24 |     let x = 1;
   |         -
   |         |
   |         first assignment to `x`
   |         help: consider making this binding mutable: `mut x`
...
27 |     x += 1;
   |     ^^^^^^ cannot assign twice to immutable variable

For more information about this error, try `rustc --explain E0384`.
error: could not compile `first` (bin "first") due to 1 previous error
```

## Primitives: Scalar Types

- Signed integers: `i8`, `i16`, `i32`, `i64`, `i128` and `isize`
- Unsigned integers: `u8`, `u16`, `u32`, `u64`, `u128` and `usize`
- Floating point: `f32`, `f64`
- `char`: Unicode scalar values like `'a'`, `'α'` and `'∞'`
- `bool`: either `true` or `false`
- unit type: `()`

## Primitives: Compound Types


- Arrays: `[1, 2, 3]`
- Tuples: `(1, true)`

## Standard library

```rust
std::string::String
std::vec::Vec<T>
std::boxed::Box<T>
std::rc::Rc<T>
std::sync::Arc<T>
```


## Standard library: allocator

```rust
std::string::String
std::vec::Vec<T, A = Global>
std::boxed::Box<T, A = Global>
std::rc::Rc<T, A = Global>
std::sync::Arc<T, A = Global>
```

## Data structures: struct

```rust
struct Pose {
    x: f64,
    y: f64,
}
```

## Data structures: enum

```rust
enum Mode {
    Idle,
    Move(Pose, f64),
}
```

## Data structures: composition

```rust
struct Robot {
    name: String,
    pose: Pose,
    mode: Mode,
}
```

## Generic Data Types

```rust
struct Transform<Scalar, Angle> {
    center: (Scalar, Scalar),
    angle: Angle,
    scale: Scalar,
}
```

## `std::result::Result`

```rust
enum Result<T, E> {
   Ok(T),
   Err(E),
}
```

. . .

```rust
type MyRet = Result<f64, f64>;
let x = MyRet::Ok(4.25);
let y = MyRet::Err(f64::NAN);

x.is_ok();            // true
x.is_err();           // false
x.map(|n| n * 2.0);   // Ok(8.5)
y.is_ok();            // false
y.is_err();           // true
y.map(|n| n * 2.0);   // Err(NAN)
```

## Results: example

```rust
let file = File::create("data.txt");
match file {
    Err(e) => eprintln!("cant create file: {e:?}"),
    Ok(mut f) => {
        let ret = f.write_all(b"hello");
        match ret {
            Err(e) => eprintln!("cant create file: {e:?}"),
            Ok(()) => println!("file written."),
        }
    }
}
```

## Results: shortcut

```rust
fn main() -> std::io::Result<()> {
    let mut file = File::create("data.txt")?;
    file.write_all(b"hello")?;
    println!("file written.");
    Ok(())
}
```

. . .

```rust
type std::io::Result<T> = Result<T, std::io::Error>;
```

## `std::option::Option`

```rust
enum Option<T> {
    None,
    Some(T),
}
```

. . .

```rust
type MyOpt = Option<f64>;
let x = MyOpt::Some(4.25);
let y = MyOpt::None;

x.is_some();          // true
x.is_none();          // false
x.map(|n| n * 2.0);   // Some(8.5)
y.is_some();          // false
y.is_none();          // true
y.map(|n| n * 2.0);   // None
```



## Traits

```rust
trait SetSpeed {
    fn set_speed(&mut self, tgt: f64) -> Result;
}
```

. . .

```rust
impl SetSpeed for Robot {
    fn set_speed(&mut self, tgt: f64) -> Result {
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
async fn main() -> Result {
    let port = 1234;
    tokio::spawn(async move {
        serve(port).await;
    });

    let mut client = Client::connect(port).await?;
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

## Ecosystem

- PAC: Peripheral Access Crates
- HAL: Hardware Abstraction Layers
- embedded-hal

. . .

ref. <https://www.youtube.com/watch?v=vLYit_HHPaY>

## Frameworks

- [RTIC](https://rtic.rs/)
- [Embassy](https://embassy.dev/)

# Web

## Leptos

![Fast full-stack web apps in Rust](media/leptos.png){width=80%}

# Tooling

## Clippy

```sh
$ rustup component add clippy
$ cargo clippy
$ cargo clippy --fix
```

## espflash

```sh
$ cargo install probe-rs-tools
$ cargo embed
```

## leptos

```sh
$ cargo install cargo-leptos
$ cargo leptos watch
```

# Démo !

## toy example

\url{https://github.com/nim65s/RobotS}

# Applications

## Shell utils

- grep → [ripgrep](https://github.com/BurntSushi/ripgrep)
- find → [fd](https://github.com/sharkdp/fd)
- ls → [LSDeluxe](https://github.com/lsd-rs/lsd) / [eza](https://github.com/eza-community/eza)
- du → [dust](https://github.com/bootandy/dust)
- cat → [bat](https://github.com/sharkdp/bat)
- ctrl-r → [zoxide](https://github.com/ajeetdsouza/zoxide)
- terminal → [alacritty](https://github.com/alacritty/alacritty)
- prompt → [starship](https://starship.rs/)
- history → [atuin](https://github.com/atuinsh/atuin)
- make → [just](https://github.com/casey/just)
- watch → [watchexec](https://github.com/watchexec/watchexec) / [bacon](https://github.com/Canop/bacon)
- screen / tmux → [zellij](https://github.com/zellij-org/zellij)
- diff → [delta](https://github.com/dandavison/delta)
- bash → [nushell](https://github.com/nushell/nushell)

## Tools for other langages

### Python

- [ruff](https://github.com/astral-sh/ruff)
- [uv](https://github.com/astral-sh/uv)

### JavaScript

- [deno](https://github.com/denoland/deno)
- [parcel](https://parceljs.org/)


# Alternatives

## Similar

- [Go](https://go.dev/)
- [Swift](https://www.swift.org/)

## Even more modern

- [Zig](https://ziglang.org/)

# Limitations

## Learning curve

Not that easy

## No shared objects

Recompile all the things

## Interractions with outside world

You might need nix ;)

## Questions ?

Thanks for your attention :)

### References

- <https://doc.rust-lang.org/rust-by-example/>
- <https://doc.rust-lang.org/book/>

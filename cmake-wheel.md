---
title: CMake Wheel
subtitle: Gérez vos projects CMake et leurs dépendances avec pip
theme: laas
data: 2022-11-19
author: Guilhem Saurel
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://nim65s.github.io/talks/cmake-wheel.pdf`](https://nim65s.github.io/talks/cmake-wheel.pdf)

### Under License

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

## This presentation (continued)

### Source

\centering

[`https://github.com/nim65s/talks :
cmake-wheel.md`](https://github.com/nim65s/talks/blob/main/cmake-wheel.md)

### Discussions

\centering

\url{https://matrix.to/\#/room/\#cmake-wheel:matrix.org}

## CMake

- C / C++ (et plus si affinitées)
- GCC / LLVM / MSVC / Intel / …
- Linux / *BSD / macOS / Windows / …

![CMake](media/cmake.png){height=2cm}

## Modern CMake

```cmake
find_package(Boost REQUIRED COMPONENTS regex)
add_library(pipo SHARED pipo.hpp pipo.cpp)
include_directories(${Boost_INCLUDE_DIRS})
target_link_libraries(pipo PUBLIC
    ${Boost_LIBRARIES})
```

. . .

```diff
-include_directories(${Boost_INCLUDE_DIRS})
-target_link_libraries(pipo PUBLIC
-    ${Boost_LIBRARIES})
+target_link_libraries(pipo PUBLIC Boost::regex)
```
. . .

=> Paquets relocalisables

## pip

```
python -m pip install --user django
```

## PEP 517

> A build-system independent format for source trees

Permet à n’importe qui de créer un système de build en écrivant une fonction:

```python
def build_wheel(
        wheel_directory,
        config_settings=None,
        metadata_directory=None,
):
    ...
```

## CMake Wheel

```python
from subprocess import run

def build_wheel(...):
    run("cmake -S src -B build")
    run("cmake --build build")
    run("cmake --build build -t test")
    run("cmake --install build")
```

## Wheel

PEP 427:

> A wheel is a ZIP-format archive with a specially formatted file name and the .whl extension.


## Design

- `-DCMAKE_INSTALL_PREFIX=${SITELIB}/cmeel.prefix`
- `${SITELIB}/cmeel.pth`
- `…/bin`: `cmeel.run:cmeel_run`
- set relative binaries `RPATH`
- helpers for `$CMAKE_PREFIX_PATH`, `$LD_LIBRARY_PATH`, …


## References

- <https://github.com/cmake-wheel/cmeel>
- <https://github.com/cmake-wheel/cmeel-example>

. . .

- `python -m pip install cmeel-example`
- `python -m pip install \ git+https://github.com/cmake-wheel/cmeel-example.git`

. . .

- `cmeel-add 3 4`
- `python -c "import cmeel_example; print(cmeel_example.cmeel_add(3, 4))"`

## C’est tout pour moi !

La parole est à vous :)

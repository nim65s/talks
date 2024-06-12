---
title: Conception Orientée Objet, Forges
subtitle: Université Toulouse Paul Sabatier - KEAR9RA1
theme: laas
date: 2022-01-25
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
conception-orientee-objet-forges.pdf`](https://homepages.laas.fr/gsaurel/talks/conception-orientee-objet-forges.pdf)

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
conception-orientee-objet-forges.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/conception-orientee-objet-forges.md)

### Discussions

\centering

\url{https://matrix.to/\#/\#conception-orientee-objet:laas.fr}

# Introduction

## What are software forges

- Software management
    - git repository (web, HTTPS, SSH)
    - authorizations
    - issue tracker

## Hierarchy

1. domain
2. username *OR* group (organization)
3. project


- `https:// gitlab.laas.fr / gsaurel / talks`
- `https:// github.com / nim65s / talks`

## Issues

- bug fix / feature request
- Github / Gitlab: `#4`
- referencable from git:
    - `git commit -m "add test for user input, ref #4"`
    - `git commit -m "sanitize user input, fix #4"`

# Branches

## Goal

![nvie](media/nvie.png)

## Usual branches

- default: `master` or `main`
- `devel`, `stable`
- `issue/5`
- `topic/something`

# Forks

## 2 types of fork

- scission (software development)
    - document motivations
    - rename
    - change logo / website etc.
    - ensure compatibility
- collaboration (git forges)
    - try to keep synchronized


## 2 types of fork

- scission (software development)
    - document motivations
    - rename
    - change logo / website etc.
    - ensure compatibility
- **collaboration (git forges)**
    - try to keep synchronized

## Work locally with multiple forks

```
git clone --recursive \
        git@gitlab.laas.fr:gsaurel/talks.git
cd talks
git remote add gepetto \
        git@gitlab.laas.fr:gepetto/talks.git
```

. . .

```
git pull gepetto main
git push origin main
```

## Git shortcut

```bash
git config --global \
    url."git@github.com:".insteadOf \
    "https://github.com/"
```

## SSH shortcut

```ini
# ~/.ssh/config
Host gh
    HostName github.com
    User git
```

```
git clone --recursive gh:nim65s/talks
```

# Requests

## Gitlab

![Merge Request](media/mr.png)

## Github

![Pull Request](media/pr.png)

# CI

## Gitlab

```yml
# .gitlab-ci.yml
image: gsaurel/talks

build:
  script:
    - make

test:
  script:
    - make test
```

## Github

```yml
# .github/workflows/build.yml
name: Build
on: [push,pull_request]

jobs:
  build:
    name: markdown → PDF
    runs-on: ubuntu-latest
    container: nim65s/talks
    steps:
      - uses: actions/checkout@v3
      - run: make
```

# Workflows

## Example

![nvie](media/nvie.png)

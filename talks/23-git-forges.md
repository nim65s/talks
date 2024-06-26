---
title: "Git: Forges"
subtitle: Issues, Branches, Forks, Requests, CI, and Workflows
theme: laas
date: 2023-12-01
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
23-git-forges.pdf`](https://homepages.laas.fr/gsaurel/talks/23-git-forges.pdf)

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
23-git-forges.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/23-git-forges.md)

### Discussions

\centering

<!-- \href doesn't like #, so let's directly use \url -->
\url{https://im.laas.fr/\#/room/\#git-forges:laas.fr}

## Outline

\tableofcontents

# Introduction

## What are software forges

- Software management
    - git repository (web, HTTPS, SSH)
    - authorizations
    - issue tracker

. . .

- Project management
    - milestones
    - assignees
    - boards

## Hierarchy

1. domain
2. username *OR* group (organization)
3. project


- `https:// gitlab.laas.fr / gsaurel / talks`
- `https:// github.com / gepetto / example-adder`


## Issues (software management)

- bug fix / feature request
- Github / Gitlab: `#4`
- referencable from git:
    - `git commit -m "add user input test, ref #4"`
    - `git commit -m "sanitize user input, fix #4"`


## Tasks (project management)

- labels
- discussions
- boards (or table / roadmap)

. . .

- open / close

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
git clone git@github.com:gsaurel/project.git
cd project
git remote add team \
        git@github.com:team/project.git
```

. . .

```
git pull team main
git push origin main
```

## SSH shortcut

```ini
# ~/.ssh/config
Host gl
    HostName gitlab.laas.fr
    User git
Host gh
    HostName github.com
    User git
```

```
git clone gl:gsaurel/project
git remote add team gh:team/project
```

# Requests

## Gitlab

![Merge Request](media/mr.png)

## Gitlab from command line

```
git push -o merge_request.create \
         -o merge_request.target=devel \
         origin topic/something
```

## Github

![Pull Request](media/pr.png)

## Github from command line

Required: https://cli.github.com/

```
gh pr create
```

# CI

## Gitlab

```yml
# .gitlab-ci.yml
image: gitlab.laas.fr:4567/gsaurel/talks

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
    name: Transpile markdown sources into PDF
    runs-on: nim65s/talks
    steps:
      - uses: actions/checkout@v4
      - run: make
```

# Workflows

## Example

![nvie](media/nvie.png)

# End notes

## References

<https://learngitbranching.js.org/>
<https://nvie.com/posts/a-successful-git-branching-model/>
<https://docs.github.com/fr/get-started/quickstart/github-flow>

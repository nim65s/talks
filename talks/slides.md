---
title: J’ai fait mes slides !
theme: laas
date: 2024-06-27
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
header-includes:
- \titlegraphic{\includegraphics[height=0.5cm]{media/capitoul-2024.png}}
urls:
- name: Capitoul
  url: https://capitoul.org/ProgrammeReunion20240627
---

# \LaTeX

```latex
\documentclass[11pt]{report}
\usepackage[latin1]{inputenc}
\usepackage[francais]{babel}

\begin{document}
Hello Capitoul !
\end{document}
```

# Beamer

```latex
\documentclass{beamer}

\title{my document title}
\author{Me}

\begin{document}
  \begin{frame}{my slide title}
    \begin{itemize}
      \item bla bla
      \item blah
    \end{itemize}
  \end{frame}
\end{document}
```

# Theme

```latex
\defbeamertemplate*{frametitle}{laas}[1][] {
  \vskip.5cm%
  \begin{beamercolorbox}[wd=\paperwidth,ht=0cm]{frametitle}
    \begin{tikzpicture}
      \useasboundingbox[fill=white](0,0) rectangle(12.8,1.2);
      \node[inner sep=0pt] (laas) at (1,0.6) {
        \includegraphics[height=1cm]{LogoLAAS-2016.png} };
      \fill[color=laasbleuclair] (1.98,0) rectangle(12.8,1.2);
      \fill[color=laasbleuanthracite] (2,0) rectangle(12.79,1.12);
      \fill[color=white] (1.99,0.1) rectangle(12.65,0.8);
      \node[color=laasbleuclair,anchor=west,font=\large] at (2.05,0.4){
        \insertframetitle };
    \end{tikzpicture}
  \end{beamercolorbox}
}
```

# pandoc: markdown + yaml

```markdown
---
title: my document title
author: me
---

# my slide title

- bla bla
- blah
```

# Makefile

```makefile
SOURCES = $(wildcard talks/*.md)
OUTPUTS = $(SOURCES:talks/%.md=public/%.pdf)

all: ${OUTPUTS}

public/%.pdf: talks/%.md references.bib
    pandoc -s \
        -t beamer \
        --citeproc \
        --bibliography references.bib \
        --highlight-style kate \
        --pdf-engine xelatex \
        --fail-if-warnings \
        -o $@ $<
```

# Watchexec

```makefile
watch:
    watchexec -r -e md -c reset make -j
```

# Index.html

```python
from pathlib import Path


html = "<html><head><title>My talks</title></head>"
html += "<body><h1>My talks:</h1><ul>"

for f in sorted(Path("talks").glob("*.md")):
    html += f'<li><a href="{f.stem}.pdf">{f.stem}.pdf</a></li>'

html += "</ul></html>"

with Path("public/index.html").open("w") as f:
    f.write(html)
```

#  pyyaml + jinja

```djangotemplate
<html>
    <head>
        <meta charset="utf-8">
        <title>My talks</title>
    </head>
    <body>
        <h1>My talks</h1>
        {% for pdf, head in talks %}
            <h2>{{ head.title }}</h2>
            {% if head.subtitle %}
                <h3>{{ head.subtitle }}</h3>
            {% endif %}
            <a href="{{ pdf }}">{{ pdf }}</a>
        {% endfor %}
    </body>
</html>
```

# Tailwind CSS

```djangotemplate
<html>
    <head>
        <meta charset="utf-8">
        <title>My talks</title>
        <link href="./style.css" rel="stylesheet">
    </head>
    <body class="bg-indigo-50 text-indigo-950
            dark:bg-indigo-800 dark:text-indigo-50">
            <!-- contenu -->
    </body>
</html>
```

<https://homepages.laas.fr/gsaurel/talks/>
<https://nim65s.github.io/talks/>

# Github Actions + Docker

```yaml
jobs:
  build:
    name: markdown → PDF
    runs-on: ubuntu-latest
    container:
      image: nim65s/talks
    steps:
      - uses: actions/checkout@v3
      - run: make
      - uses: actions/upload-pages-artifact@v1
        with:
          path: public/
```

# Un setup simple

- latex + beamer + theme (texlive / miktex + bidouilles)
- markdown + yaml
- pandoc (haskell: cabal / stack)
- fontes (bidouilles)
- watchexec (rust: cargo install / cargo binstall)
- pdfpc (vala, gtk: cmake)
- makefile
- python + pyyaml + jinja (pip / poetry / …)
- tailwind css (npm / yarn / …)
- github & gitlab + ci/cd
- docker
- ssh / rsync / git

# Notre seigneur et sauveur

\center
![Nix](media/nix-snowflake-colours.png){width=7cm}

# Nix

```nix
stdenvNoCC.mkDerivation {
  nativeBuildInputs = [
    nodePackages.tailwindcss
    pandoc
    (python3.withPackages (p: [
      p.jinja2
      p.pyyaml
    ]))
    source-code-pro
    (texlive.combined.scheme-full.withPackages (_: [
      laas-beamer-theme
    ]))
  ];
  installPhase = "install -Dm 644 public/* -t $out";
}
```

# Questions ?

## Cette présentatation

\centering

[`https://gitlab.laas.fr/gsaurel/talks :
slides.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/slides.md)
[`https://homepages.laas.fr/gsaurel/talks/
slides.pdf`](https://homepages.laas.fr/gsaurel/talks/slides.pdf)

## Sous license

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

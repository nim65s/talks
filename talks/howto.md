---
title: Quick MarkDown Reference
subtitle: Beamer presentation with Pandoc
theme: laas
date: 2021-10-08
author: Guilhem Saurel
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

- [`gitlab.laas.fr/gsaurel/talks : howto.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/howto.md)
- [`homepages.laas.fr/gsaurel/talks/howto.pdf`](https://homepages.laas.fr/gsaurel/talks/howto.pdf)

### Under License

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

## Table of contents

\tableofcontents

# First Part

## Slide title

How-to Slides

Formating: *em* **bold** `mono` ~~strikethrough~~
text~subscript~^superscript^

## {Un,}ordered Lists, pause

- eggs
- butter
- ham

. . .

1. Thing
2. Do
3. Words
4. You

## Code
```python
#!/usr/bin/env python3
from math import pi as π

class Circle:
    """Define a circle from its radius."""
    def __init__(self, r):
        # such maths, very difficult, wow
        if r < 0:
            raise AttributeError('wrong radius')
        self.P = 2 * π * r
        self.S = π * r ** 2
```

# Second Part

## Maths

$\begin{aligned}
\vec{\nabla} \cdot  \vec{\mathcal{E}} & = \frac{\rho}{\epsilon_0} \\
\vec{\nabla} \times \vec{\mathcal{E}} & = -\frac{\partial \vec{\mathcal{B}}}{\partial t} \\
\vec{\nabla} \cdot  \vec{\mathcal{B}} & = 0 \\
\vec{\nabla} \times \vec{\mathcal{B}} & = \mu_0\vec{\mathcal{J}} + \epsilon_0\frac{\partial \vec{\mathcal{E}}}{\partial t}
\end{aligned}$

## Tables

| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|  *1*  |  `1` |  **1**  |  ~~1~~ |

## Images

![Doc](media/doc.jpg){width=5cm}

## Citations

> Look ! The trees… They're moving !

\hfill --- @transhumus

## References

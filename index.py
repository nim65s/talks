#!/usr/bin/env python3
"""Generate public/index.html."""

from pathlib import Path

from jinja2 import Template
from yaml import Loader, load

talks = []

for f in Path("talks").glob("*.md"):
    head = f.read_text().split("---")[1]
    meta = load(head, Loader=Loader)
    y = meta["date"].year
    m = meta["date"].month
    d = meta["date"].day
    talks.append((y, m, d, f.stem, meta))

talks = sorted(talks, reverse=True)

with Path("public/index.html").open("w") as f:
    f.write(Template(Path("template.html").read_text()).render({"talks": talks}))

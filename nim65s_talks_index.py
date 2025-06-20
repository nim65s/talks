#!/usr/bin/env python3
"""Generate public/index.html."""

from pathlib import Path

from jinja2 import Template
from yaml import Loader, load


def get_talks():
    talks = []

    for f in Path("talks").glob("*.md"):
        head = f.read_text().split("---")[1]
        meta = load(head, Loader=Loader)

        y = meta["date"].year
        m = meta["date"].month
        d = meta["date"].day
        talks.append((y, m, d, f.stem, meta))

    return sorted(talks, reverse=True)


def main():
    template = Template(Path("template.html").read_text())
    Path("public/index.html").write_text(template.render({"talks": get_talks()}))


if __name__ == "__main__":
    main()

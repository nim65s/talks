#!/usr/bin/env python3
"""Generate public/index.html."""

from json import dumps
from pathlib import Path
from urllib.parse import urlparse

from jinja2 import Environment
from yaml import Loader, load


def url_format(value):
    return urlparse(value).hostname


def get_talks():
    talks = []

    for f in Path("talks").glob("*.md"):
        head = f.read_text().split("---")[1]
        meta = load(head, Loader=Loader)

        y = meta["date"].year
        m = meta["date"].month
        d = meta["date"].day
        meta["date"] = meta["date"].strftime("%Y-%m-%d")
        talks.append((y, m, d, f.stem, meta))

    return sorted(talks, reverse=True)


def main():
    env = Environment()
    env.filters["url_format"] = url_format
    template = env.from_string(Path("template.html").read_text())
    icons = ["creativecommons", "github", "gitlab"]
    talks = get_talks()
    ctx = {
        "talks": talks,
        **{icon: Path(f"public/{icon}.svg").read_text() for icon in icons},
    }
    Path("public/index.html").write_text(template.render(ctx))
    Path("public/.metadata.json").write_text(dumps(talks))


if __name__ == "__main__":
    main()

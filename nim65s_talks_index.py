#!/usr/bin/env python3
"""Generate public/index.html."""

from pathlib import Path
from urllib.parse import urlparse

from jinja2 import Environment
from yaml import Loader, load


def date_format(value):
    return value.strftime("%Y-%m-%d")


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
        talks.append((y, m, d, f.stem, meta))

    return sorted(talks, reverse=True)


def main():
    env = Environment()
    env.filters["date_format"] = date_format
    env.filters["url_format"] = url_format
    template = env.from_string(Path("template.html").read_text())
    Path("public/index.html").write_text(template.render({"talks": get_talks()}))


if __name__ == "__main__":
    main()

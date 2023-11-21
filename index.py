#!/usr/bin/env python3
"""Generate public/index.html."""

from pathlib import Path

from yaml import Loader, load

html = "<html><head><title>My talks</title></head><body><h1>My talks:</h1>"

talks = {}

for f in sorted(Path().glob("*.md")):
    if f.stem == "README":
        continue
    head = f.read_text().split("---")[1]
    print(f.stem)
    meta = load(head, Loader=Loader)
    year = meta["date"].year
    talk = f'<a href="{f.stem}.pdf">{f.stem}.pdf</a>'
    if "talk-urls" in meta:
        links = [(link["name"], link["url"]) for link in meta["talk-urls"]]
        talk += ": " + ", ".join(f'<a href="{url}">{name}</a>' for name, url in links)
    talks[year] = talks.get(year, "") + f"<li>{talk}</li>"

for year, content in sorted(talks.items(), reverse=True):
    html += f"<h2>{year}</h2><ul>{content}</ul>"

html += "<h2>sources</h2><ul>"
html += '<li><a href="https://gitlab.laas.fr/gsaurel/talks">gitlab</a></li>'
html += '<li><a href="https://github.com/nim65s/talks">github</a></li>'
html += "</li></html>"

with Path("public/index.html").open("w") as f:
    f.write(html)

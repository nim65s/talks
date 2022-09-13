#!/usr/bin/env python3
"""Generate public/index.html."""

from pathlib import Path


html = "<html><head><title>My talks</title></head><body><h1>My talks:</h1><ul>"

for f in sorted(Path().glob("*.md")):
    if f.stem != "README":
        html += f'<li><a href="{f.stem}.pdf">{f.stem}.pdf</a></li>'

html += '<li><a href="src">src</a></li></ul></html>'

with Path("public/index.html").open("w") as f:
    f.write(html)

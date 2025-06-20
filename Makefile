SOURCES = $(wildcard talks/*.md)
OUTPUTS = $(SOURCES:talks/%.md=public/%.pdf)
DEST = "/usr/local/homepages/gsaurel/talks"

all: html pdfs

pdfs: ${OUTPUTS}
html: public/index.html public/style.css

public/%.pdf: talks/%.md references.bib
	pandoc -s \
		-t beamer \
		--citeproc \
		--bibliography references.bib \
		--highlight-style kate \
		--pdf-engine xelatex \
		--fail-if-warnings \
		-o $@ $<

public/index.html: ${SOURCES} nim65s_talks_index.py template.html
	nim65s-talks-index

public/style.css: style.css public/index.html
	tailwindcss -i style.css -o public/style.css

check: all

deploy:
	chmod a+r,g+w ${OUTPUTS}
	rsync -avzP --delete -e "ssh -o UserKnownHostsFile=.known_hosts" public/ gsaurel-deploy@memmos.laas.fr:${DEST}

clean:
	rm -f ${OUTPUTS} public/index.html

watch:
	watchexec -r -e md -e html -c reset make -j

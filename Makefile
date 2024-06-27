SOURCES = $(wildcard talks/*.md)
OUTPUTS = $(SOURCES:talks/%.md=public/%.pdf)
DEST = "/usr/local/homepages/gsaurel/talks"

all: ${OUTPUTS} public/index.html public/style.css

public/%.pdf: talks/%.md references.bib
	pandoc -s \
		-t beamer \
		--citeproc \
		--bibliography references.bib \
		--highlight-style kate \
		--pdf-engine xelatex \
		--fail-if-warnings \
		-o $@ $<

public/index.html: ${SOURCES} index.py template.html
	mkdir -p public
	python3 index.py

public/style.css: public/index.html style.css
	tailwindcss -i style.css -o public/style.css

check: all

deploy:
	chmod a+r,g+w ${OUTPUTS}
	rsync -avzP --delete -e "ssh -o UserKnownHostsFile=.known_hosts" public/ gsaurel-deploy@memmos.laas.fr:${DEST}

clean:
	rm -f ${OUTPUTS} public/index.html

watch:
	watchexec -r -e md -e html -c reset make -j

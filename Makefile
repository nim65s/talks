PREFIX=out

SOURCES = $(wildcard talks/*.md)
OUTPUTS = $(SOURCES:talks/%.md=public/%.pdf)
DEST = "/usr/local/homepages/gsaurel/talks"

all: css html pdfs

css: public/style.css
html: public/index.html
pdfs: ${OUTPUTS}


public/%.pdf: talks/%.md references.bib
	mkdir -p public
	pandoc -s \
		-t beamer \
		--citeproc \
		--bibliography references.bib \
		--highlight-style kate \
		--pdf-engine xelatex \
		--fail-if-warnings \
		-o $@ $<

public/index.html: ${SOURCES} nim65s_talks_index.py template.html
	mkdir -p public
	nim65s-talks-index

node_modules:
	yarn install

public/style.css: style.css template.html package.json yarn.lock node_modules
	mkdir -p public
	yarn build

check: all

install:
	mkdir -p $(PREFIX)
	install -Dm 644 public/* -t $(PREFIX)

deploy:
	chmod a+r,g+w ${OUTPUTS}
	rsync -avzP --delete -e "ssh -o UserKnownHostsFile=.known_hosts" public/ gsaurel-deploy@memmos.laas.fr:${DEST}

clean:
	rm -rf public

watch:
	watchexec -r -e md -e html -c reset make -j

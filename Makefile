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

public/index.html: ${SOURCES} nim65s_talks_index.py template.html public/creativecommons.svg
	mkdir -p public
	nim65s-talks-index

node_modules:
	yarn install

public/style.css: style.css template.html package.json yarn.lock node_modules
	mkdir -p public
	yarn css

public/creativecommons.svg: package.json yarn.lock node_modules icons.js
	mkdir -p public
	yarn svg

check: all

install:
	mkdir -p $(PREFIX)
	install -Dm 644 public/* -t $(PREFIX)

deploy:
	chmod -R a+rX,g+w public
	rsync -avzP --delete -e "ssh -o UserKnownHostsFile=.known_hosts" public/ gsaurel-deploy@memmos.laas.fr:${DEST}

clean:
	rm -rf public

watch:
	watchexec -r -e md -e html -e js -c reset make -j

update:
	yarn up
	yarn-berry-fetcher missing-hashes yarn.lock > ./pkgs/missing-hashes.json
	echo "{\"hash\": \"`yarn-berry-fetcher prefetch yarn.lock pkgs/missing-hashes.json`\"}" > ./pkgs/lock-hash.json
	nix flake update

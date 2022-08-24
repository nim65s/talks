SOURCES = $(filter-out README.md, $(wildcard *.md))
OUTPUTS = $(SOURCES:%.md=public/%.pdf)
DEST = "/usr/local/homepages/gsaurel/talks"

all: ${OUTPUTS}

public/%.pdf: %.md references.bib
	pandoc -s \
		-t beamer \
		--citeproc \
		--bibliography references.bib \
		--highlight-style kate \
		--pdf-engine xelatex \
		--fail-if-warnings \
		-o $@ $<

check: all

deploy: check
	chmod a+r,g+w ${OUTPUTS}
	rsync -avzP --delete public/ gsaurel-deploy@memmos.laas.fr:${DEST}

clean:
	rm -f ${OUTPUTS}

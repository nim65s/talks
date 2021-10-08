SOURCES = $(filter-out README.md,$(wildcard *.md))
PDFS = $(SOURCES:%.md=%.pdf)
DEST = "/usr/local/homepages/gsaurel/talks"

all: ${PDFS}

%.pdf: %.md
	pandoc -s -t beamer --highlight-style kate --pdf-engine xelatex $< -o $@

publish: all
	cp ${PDFS} ${DEST}
	chmod -R a+r ${DEST}

SOURCES = $(filter-out README.md,$(wildcard *.md))
PDFS = $(SOURCES:%.md=%.pdf)

all: ${PDFS}

%.pdf: %.md
	pandoc -s -t beamer --highlight-style kate --pdf-engine xelatex $< -o $@

publish: all
	cp ${PDFS} /usr/local/homepages/gsaurel/talks

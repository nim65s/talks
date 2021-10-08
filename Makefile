SOURCES = $(filter-out README.md,$(wildcard *.md))

all: pdf
pdf: $(SOURCES:%.md=%.pdf)

%.pdf: %.md
	pandoc -s --highlight-style kate -t beamer --pdf-engine xelatex $< -o $@

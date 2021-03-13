### -*- Makefile -*- definition file for Orgmk

SHELL = /bin/sh
OUT_DIR = out

VIEW_HTML ?= firefox
VIEW_PDF ?= okular


ifeq ($(ALLSUBDIRS),yes)
    ORG_FILES=$(shell find . -name \*.org)
    HTML_FILES=$(shell find . -name \*.html)
    PDF_FILES=$(shell find . -name \*.pdf)
else
    ORG_FILES=$(shell find . -maxdepth 1 -name \*.org)
    HTML_FILES=$(shell find . -maxdepth 1 -name \*.html)
    PDF_FILES=$(shell find . -maxdepth 1 -name \*.pdf)
endif

# turn command echo'ing back on with VERBOSE=1
ifndef VERBOSE
    QUIET := @
endif

PRINTF=$(QUIET)printf
EGREP=$(QUIET)egrep
LS=$(QUIET)ls

# variables para mover los documentos generados
# a un directorio de salida
HTML_FILES_FROM_ORG = $(patsubst %.org,%.html,$(ORG_FILES))
PDF_FILES_FROM_ORG = $(patsubst %.org,%.pdf,$(ORG_FILES))

.PHONY: html
html: $(CUR_HTML_FILES)                 # Regenerate all HTML documents from Org
	emacs --batch --find-file $(ORG_FILES) --funcall org-html-export-to-html
	mv $(HTML_FILES_FROM_ORG) $(OUT_DIR)

# export de pdf
pdf :
	pandoc $(ORG_FILES) \
       -o "$(OUT_DIR)/document.pdf" \
    -H src/options.sty \
    -N \
    --metadata-file=src/preamble.yaml \
    --from org \
    --template "src/eisvogel.tex" \
    --filter=pandoc-latex-environment \
    --filter=pandoc-citeproc   \
    --csl=src/apa.csl

	# si llegase a tener referencias
    # --biblio=meta/my-biblio.bib \
    # --filter=pandoc-crossref   \
# 	mv $(TARGET).pdf $(OUT_DIR)
.PHONY: all
all:  pdf html

.PHONY: clean
 clean:
	rm out/*

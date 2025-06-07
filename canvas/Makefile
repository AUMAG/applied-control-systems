# GMAKEFILE

ifeq ($(origin MAKE_VERSION), undefined)
$(error This Makefile must be run with GNU Make. Try 'gmake', not 'make'.)
endif

PAGESNEW = $(shell git status --porcelain pages/ | grep '^ M' | cut -c4- | xargs -n1 basename)

.ONESHELL:
.RECIPEPREFIX = >

help:
> @echo "gmakefile for canvas. Targets:"
> @echo "        pages : delete HTML sources and re-download them from Canvas"
> @echo "         send : upload HTML pages to Canvas which have been modified according to Git"

.PHONY: pages install

install:
> brew install make
> brew install js-beautify

pages:
> mkdir -p pages
> rm -f pages/*.html
> lua canvas-get-pages.lua
> html-beautify --indent-preserve-newlines -r pages/*.html

send:
> for file in $(PAGESNEW); do \
>     #echo "SEND $$file:"
>     lua canvas-send-page.lua "$$file"; \
> done
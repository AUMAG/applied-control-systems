# GMAKEFILE

ifeq ($(origin MAKE_VERSION), undefined)
$(error This Makefile must be run with GNU Make. Try 'gmake', not 'make'.)
endif

PAGESNEW = $(shell git status --porcelain pages/ | grep '^[ ]*M' | cut -c4- | xargs -n1 basename)

.ONESHELL:
.RECIPEPREFIX = >

help:
> @echo "gmake file for canvas. Targets:"
> @echo "          get : delete HTML sources and re-download them from Canvas"
> @echo "         send : upload HTML pages to Canvas which have been modified according to Git"
> @echo "      install : use brew to install dependencies"
> @echo "         edit : open Makefile in BBEdit"

.PHONY: get send install edit

get:
> mkdir -p pages
> rm -f pages/*.html
> lua canvas-get-pages.lua
> html-beautify --indent-preserve-newlines -r pages/*.html

send:
> for file in $(PAGESNEW); do \
>     lua canvas-send-page.lua "$$file"; \
> done
> git add pages/
> git commit -m "auto commit uploaded changes"

install:
> brew install make
> brew install js-beautify

edit:
> bbedit Makefile

# GMAKEFILE

ifeq ($(origin MAKE_VERSION), undefined)
$(error This Makefile must be run with GNU Make. Try 'gmake', not 'make'.)
endif

.ONESHELL:
.RECIPEPREFIX = >

help:
> @echo "gmakefile for canvas. Targets:"
> @echo "        pages : delete HTML sources and re-download them from Canvas"

.PHONY: pages install

install:
> brew install make
> brew install js-beautify

pages:
> mkdir -p pages
> rm -f pages/*.html
> lua canvas-get-pages.lua
> html-beautify --indent-preserve-newlines -r pages/*.html

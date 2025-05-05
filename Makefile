.ONESHELL:
SHELL = bash

BUILD = _build
UPLOAD = _upload
EXTRA = _extra

texsty   = $(wildcard *.cls) $(wildcard *.sty) $(wildcard *.bib) applied-control-systems.tex $(wildcard *.lua)

notesrc  = applied-control-systems.tex
topcsrc  = $(wildcard acs-0-*.tex) $(wildcard acs-1-*.tex) $(wildcard acs-2-*.tex) $(wildcard acs-3-*.tex)
pracsrc  = $(wildcard acs-prac*.tex)
worksrc  = $(wildcard acs-workshop*.tex)
extrafiles = $(notdir $(wildcard extra/*.*))

notepdf = $(notesrc:.tex=.pdf)
topcpdf = $(topcsrc:.tex=.pdf)
workpdf = $(worksrc:.tex=.pdf)
pracpdf = $(pracsrc:.tex=.pdf)

buildnotepdf  = $(addprefix $(BUILD)/,$(notepdf))
buildtopcpdf  = $(addprefix $(BUILD)/,$(topcpdf))
buildworkpdf  = $(addprefix $(BUILD)/,$(workpdf))
buildpracpdf  = $(addprefix $(BUILD)/,$(pracpdf))

uploadnotepdf = $(addprefix $(UPLOAD)/,$(notepdf))
uploadtopcpdf = $(addprefix $(UPLOAD)/,$(topcpdf))
uploadworkpdf = $(addprefix $(UPLOAD)/,$(workpdf))
uploadpracpdf = $(addprefix $(UPLOAD)/,$(pracpdf))
uploadextra   = $(addprefix $(EXTRA)/,$(extrafiles))

.PHONY: help edit topics pracs workshops notes all upload uploadnotes clean figures

help:
	@echo 'APPL CONTROL SLIDES MAKEFILE:'
	@echo ''
	@echo '      topics - PDFs for each topic'
	@echo '       pracs - PDFs for each prac'
	@echo '   workshops - PDFs for each workshops'
	@echo '       notes - Combined lecture notes'
	@echo '         all - All of the above'
	@echo '   upload[*] - Make [*] as above (e.g. "uploadpracs" reqs "pracs") and upload the results'
	@echo '       extra - Upload all files in extra/ to Canvas'
	@echo '       clean - Remove cruft in working directly and all _build/ files'
	@echo '        edit - Edit this Makefile'

test:
	echo $(extrafiles)
	
edit:
	edit Makefile || bbedit Makefile

topics: $(buildtopcpdf)
pracs: $(buildpracpdf)
workshops: $(buildworkpdf)
notes: $(buildnotepdf)
all: topics pracs workshops notes
extra: $(uploadextra)

uploadtopics: $(uploadtopcpdf)
uploadpracs: $(uploadpracpdf)
uploadworkshops: $(uploadworkpdf)
uploadnotes: $(uploadnotepdf)
uploadall: uploadtopics uploadpracs uploadworkshops uploadnotes

clean:
	rm -fv *.log *.aux *.nav *.snm *.gz *.toc *.vrb *-blx.bib *.run.xml
	mkdir -p $(BUILD)
	rm -fv $(BUILD)/*.*
	echo "The contents of this folder are auto-generated and can be safely deleted." > $(BUILD)/README.md

$(UPLOAD)/%.pdf: $(BUILD)/%.pdf
	mkdir -p $(UPLOAD)
	@echo '\n\nUPLOAD\n\n'
	lua canvas-acs-upload-file.lua $<  &&  cp -f $< $@

$(EXTRA)/%: extra/%
	mkdir -p $(EXTRA)
	@echo '\n\nEXTRA\n\n'
	lua canvas-acs-upload-file.lua $<  &&  cp -f $< $@

$(BUILD)/%.pdf: %.tex
	mkdir -p $(BUILD)
	cp -f $< $(BUILD)/
	cp -f $(texsty) $(BUILD)/
	cp -f $(topcsrc) $(BUILD)/
	@echo "\n\nCOMPILE\n\n"
	cd $(BUILD); xelatex $*
	cd $(BUILD); bibtex  $* || echo "BibTeX may have failed."
	cd $(BUILD); xelatex $*
	echo "\n\nDone!\n\n"

$(BUILD)/applied-control-systems.pdf: applied-control-systems.tex $(topcsrc)
	mkdir -p $(BUILD)
	cp -f $^ $(BUILD)/
	cp -f $(texsty) $(BUILD)/
	cp -f $(topcsrc) $(BUILD)/
	@echo "\n\nCOMPILE\n\n"
	cd $(BUILD); xelatex applied-control-systems
	cd $(BUILD); bibtex  applied-control-systems || echo "BibTeX may have failed."
	cd $(BUILD); xelatex -interaction=batchmode applied-control-systems
	echo "\n\nDone!\n\n"

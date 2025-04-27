.ONESHELL:
SHELL = bash

BUILD = _build
UPLOAD = _upload

texsty   = $(wildcard *.cls) $(wildcard *.sty) $(wildcard *.bib) applied-control-systems.tex $(wildcard *.lua)

notesrc  = applied-control-systems.tex
topcsrc  = $(wildcard acs-0-*.tex) $(wildcard acs-1-*.tex) $(wildcard acs-2-*.tex) $(wildcard acs-3-*.tex)
pracsrc  = $(wildcard acs-prac*.tex)
worksrc  = $(wildcard acs-workshop*.tex)

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

.PHONY: help edit topics pracs workshops notes all upload uploadnotes clean figures

help:
	@echo 'APPL CONTROL SLIDES MAKEFILE:'
	@echo ''
	@echo '      topics - PDFs for each topic'
	@echo '       pracs - PDFs for each prac'
	@echo '   workshops - PDFs for each workshops'
	@echo '       notes - Combined lecture notes'
	@echo '         all - All of the above'
	@echo '      upload - Upload all PDFs to MyUni (ALL -- not smart!)'
	@echo '       clean - Remove all build files'
	@echo '        edit - Edit this Makefile'

edit:
	edit Makefile || bbedit Makefile

topics: $(buildtopcpdf)
pracs: $(buildpracpdf)
workshops: $(buildworkpdf)
notes: $(buildnotepdf)
all: topics pracs workshops notes

uploadtopics: $(uploadtopcpdf)
uploadpracs: $(uploadpracpdf)
uploadworkshops: $(uploadworkpdf)
uploadnotes: $(uploadnotepdf)
uploadall: uploadtopics uploadpracs uploadworkshops uploadnotes

upload: $(uploadtopcpdf)
	cd ../Canvas/; lua canvas-acs-upload.lua 

clean:
	rm -fv *.log *.aux *.nav *.snm *.gz *.toc *.vrb *-blx.bib *.run.xml
	mkdir -p $(BUILD)
	mkdir -p $(UPLOAD)
	rm -fv $(BUILD)/*.*
	echo "The contents of this folder are auto-generated and can be safely deleted." > $(BUILD)/README.md

$(UPLOAD)/%.pdf: $(BUILD)/%.pdf
	mkdir -p $(UPLOAD)
	cp -f $< $@
	(cd $(UPLOAD); lua ../canvas-acs-upload-file.lua $*.pdf)
	
$(BUILD)/%.pdf: %.tex
	mkdir -p $(BUILD)
	cp -f $< $(BUILD)/
	cp -f $(texsty) $(BUILD)/
	cp -f $(topcsrc) $(BUILD)/
	cd $(BUILD); xelatex $(basename $(notdir $@))
	cd $(BUILD); bibtex  $(basename $(notdir $@)) || echo "BibTeX may have failed."
	cd $(BUILD); xelatex $(basename $(notdir $@))

$(BUILD)/applied-control-systems.pdf: applied-control-systems.tex $(topcsrc)
	mkdir -p $(BUILD)
	cp -f $^ $(BUILD)/
	cp -f $(texsty) $(BUILD)/
	cp -f $(topcsrc) $(BUILD)/
	cd $(BUILD); xelatex applied-control-systems
	cd $(BUILD); bibtex applied-control-systems || echo "BibTeX may have failed."
	cd $(BUILD); xelatex applied-control-systems
	echo "Done!"
	date

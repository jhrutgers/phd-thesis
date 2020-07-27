SHELL = /bin/bash
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
COMMA := ,

COVERS = full cropped front back

.PHONY: all force $(COVERS)
all: $(COVERS) example

force: dist-clean all

.SECONDEXPANSION:
$(COVERS): cover-$$@.pdf

cover-%.pdf: cover-%.tex cover.tex cover.cls ../info.tex
	@$(MAKE) --no-print-directory clean
	latexmk cover-$*

preview: preview-full

preview-%: cover-%.tex clean
	latexmk -pvc cover-$*

cover-front.tex: Makefile
	@echo '\PassOptionsToClass{frontonly}{cover}\input{cover}' > $@

cover-front-hires.tex: Makefile
	@echo '\PassOptionsToClass{frontonly,hires}{cover}\input{cover}' > $@

cover-back.tex: Makefile
	@echo '\PassOptionsToClass{backonly}{cover}\input{cover}' > $@

cover-cropped.tex: Makefile
	@echo '\PassOptionsToClass{cropped}{cover}\input{cover}' > $@

cover-full.tex: Makefile
	@echo '\PassOptionsToClass{}{cover}\input{cover}' > $@

.PHONY: example
example: cover-example.png cover-front.png
cover-example.png: cover-cropped.pdf
	gs -q -dSAFER -dBATCH -dNOPAUSE -dDOINTERPOLATE -sDEVICE=png16m -r150 -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -sOutputFile=$@ $<

cover-front.png: cover-front-hires.pdf
	gs -q -dSAFER -dBATCH -dNOPAUSE -dDOINTERPOLATE -sDEVICE=png16m -r300 -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -sOutputFile=$@ $<

.PHONY: clean dist-clean
clean:
	-rm -rf *.aux *.fdb_latexmk *.log cover-{full,front,front-hires,cropped,back}.out *.rs *.xmpdata pdfx-1a.xmpi *.fls

dist-clean: clean
	-rm -rf cover-{$(subst $(SPACE),$(COMMA),$(COVERS))}{.pdf,.tex} cover-example.png


SHELL=/bin/bash

all: grav.pdf

grav.pdf: grav.tex grav_frames.tex
	latexmk -pdf -g $<

grav_frames.tex: grav
	./$< > $@

grav: grav.cc
	g++ -Wall -Werror -o $@ $<

clean:
	-latexmk -C grav.tex
	-rm -rf grav grav_frames.tex

dist-clean: clean


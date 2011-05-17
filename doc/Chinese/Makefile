#
# http://www.maxwit.com
#

DESTDIR = release

#BOOK_TEX := linux-beginner.tex
ART_TEX := $(wildcard *.art.tex)
ART_PDF := $(ART_TEX:%.tex=%.pdf)

SLI_TEX := $(wildcard *.sli.tex)
SLI_PDF := $(SLI_TEX:%.tex=%.pdf)

#TMP_OUT := $(BOOK_TEX:%.tex=%.*) $(ART_TEX:%.tex=%.*) $(SLI_TEX:%.tex=%.*)

all: $(ART_PDF)
	@echo
	@echo "article list:"
	@ls -lh $(ART_PDF)
	@echo
	@echo "slide list:"
	@ls -lh $(SLI_PDF)
	@echo
	@echo "book list:"
	@ls -lh $(BOOK_PDF)
	@echo

# fixme
%.art.dvi: %.art.tex
	latex $<
	latex $<

%.pdf: %.dvi
	dvipdfmx $<

install:
	@mkdir -vp $(DESTDIR)/slide $(DESTDIR)/article
	@for fn in `ls *.sli.pdf`; \
	do \
		cp -v $${fn} $(DESTDIR)/slide/$${fn%sli.pdf}pdf; \
	done
	@for fn in `ls *.art.pdf`; \
	do \
		cp -v $${fn} $(DESTDIR)/article/$${fn%art.pdf}pdf; \
	done
	@cp -v $(BOOK_PDF) $(DESTDIR)/

clean:
	@for set in $(wildcard *.tex); \
	do \
		for fn in `ls $${set%tex}*`; \
		do \
			if [ $${fn##*.} != tex ]; then rm -vf $$fn; fi \
		done \
	done

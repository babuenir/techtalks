gen-images := $(patsubst %.svg,%.png,$(wildcard *.svg))
slides 	   := $(patsubst %.txt,%.html,$(wildcard *.txt))
pdfs	   := $(patsubst %.txt,%.pdf,$(wildcard *.txt))

all: $(pdfs)

$(pdfs): images $(slides)
images: $(gen-images)

%.pdf:%.html
	deck2pdf --profile=deckjs --quality=75 --width=1400 --height=800 $< $@

%.html:%.txt
	asciidoc -a asciimath -b deckjs -o $@ $<

%.png:%.svg
	inkscape -e $@ -f $<

clean:
	rm -f *.pdf *.html *.md5 *.png *.log

junk-clean:
	rm -f *~

distclean: clean junk-clean

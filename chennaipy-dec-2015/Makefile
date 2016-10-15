gen-images := $(patsubst %.svg,%.png,$(wildcard *.svg))
slides 	   := $(patsubst %.txt,%.html,$(wildcard *.txt))
pdfs	   := $(patsubst %.txt,%.pdf,$(wildcard *.txt))

all: $(slides)
	mkdir -p output
	cp *.html *.png *.jpg output

$(slides): images
images: $(gen-images)

%.html:%.txt
	asciidoc -a asciimath -b deckjs -o $@ $<

%.png:%.svg
	inkscape -e $@ -f $<

clean:
	rm -rf *.pdf *.html *.md5 *.png *.log output

junk-clean:
	rm -f *~

distclean: clean junk-clean

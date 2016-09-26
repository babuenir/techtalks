images := u-boot-background.png pirate.png typical-boot-flow.png
slide := u-boot-boot-flow.html

all: $(slide)

%.png: %.svg
	inkscape -e $@ -f $< -d 90
%.png: %.dia
	dia -t png -e $@  $<

$(slide): $(images)
	hovercraft u-boot-boot-flow.rst output

.PHONY: all clean
clean:
	rm -fr output
	rm -f *.png

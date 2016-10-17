images := u-boot-background.png pirate.png typical-boot-flow.png
slide := u-boot-boot-flow.html

all: $(slide)

%.png: %.svg
	inkscape -T -e $@ -f $< -d 90

$(slide): $(images)
	hovercraft u-boot-boot-flow.rst output
	mv output/index.html output/u-boot-boot-flow.html

.PHONY: all clean
clean:
	rm -fr output
	rm -f *.png

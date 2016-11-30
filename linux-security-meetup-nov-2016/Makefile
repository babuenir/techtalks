images := dirtycow.png
slide := dirty-cow.html

all: $(slide)

%.png: %.svg
	inkscape -T -e $@ -f $< -d 90

$(slide): $(images)
	hovercraft $(slide:.html=.rst) output
	mv output/index.html output/$(slide)

.PHONY: all clean
clean:
	rm -fr output
	rm -f *.png

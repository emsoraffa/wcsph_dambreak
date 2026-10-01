CFLAGS+= -fopenmp -O2
LDLIBS+= -lm
TARGETS=wcsph_dambreak
IMAGES=$(patsubst data/%.txt,images/%.png,$(wildcard data/*.txt))
.PHONY: all dirs plot clean
all: dirs ${TARGETS}
wcsph_dambreak: wcsph_dambreak.c wcsph_dambreak.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ wcsph_dambreak.c $(LDFLAGS) $(LDLIBS)
dirs:
	mkdir -p data images
plot: ${IMAGES}
images/%.png: data/%.txt
	./plot_image.sh $<
clean:
	-rm -f data/*.txt images/*.png ${TARGETS}

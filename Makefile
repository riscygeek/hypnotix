DESTDIR ?=
PREFIX ?= /usr/local

all: buildmo

buildmo:
	@echo "Building the mo files"
	# WARNING: the second sed below will only works correctly with the languages that don't contain "-"
	for file in `ls po/*.po`; do \
		lang=`echo $$file | sed 's@po/@@' | sed 's/\.po//' | sed 's/hypnotix-//'`; \
		install -d usr/share/locale/$$lang/LC_MESSAGES/; \
		msgfmt -o usr/share/locale/$$lang/LC_MESSAGES/hypnotix.mo $$file; \
	done \

clean:
	rm -rf usr/share/locale build

build/bin/hypnotix: usr/bin/hypnotix
	mkdir -p build/bin
	sed "s#@PREFIX@#${PREFIX}#" $< > $@

build/lib/hypnotix/%.py: usr/lib/hypnotix/%.py
	mkdir -p build/lib/hypnotix
	sed 's#@PREFIX@#${PREFIX}#' $< > $@

build/share/%: usr/share/%
	install -D $< $@

FILES = bin/hypnotix lib/hypnotix/common.py lib/hypnotix/hypnotix.py lib/hypnotix/mpv.py lib/hypnotix/xtream.py $(shell find usr/share -type f | sed 's@usr/@@')

$(DESTDIR)$(PREFIX)/%: build/% all
	install -vD $< $@

install: $(patsubst %,$(PREFIX)/%,$(FILES))
	glib-compile-schemas $(DESTDIR)$(PREFIX)/share/glib-2.0/schemas

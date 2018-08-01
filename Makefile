DESTDIR =
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib

PYTHON ?= python

GV_BINDIR = $(LIBDIR)/gverify
PYTHON_BASENAME = $$($(PYTHON) -c 'import os.path, sys; print(os.path.basename(sys.executable))')

.PHONY: all clean install

BUILT_SOURCES = build/gverify build/gvgit build/gv-install \
	build/gvgit-get-keyids

all: $(BUILT_SOURCES)
clean:
	rm -f $(BUILT_SOURCES)
	[ ! -d build ] || rmdir build

build/gverify: gverify
	mkdir -p build
	rm -f $@ $@.tmp
	sed -e '/GV_BINDIR/s@=.*@=$(BINDIR)@' $< > $@.tmp
	chmod a-w,a+x $@.tmp
	mv $@.tmp $@

build/gvgit: gvgit
	mkdir -p build
	rm -f $@ $@.tmp
	sed -e '/GV_BINDIR/s@=.*@=$(GV_BINDIR)@' $< > $@.tmp
	chmod a-w,a+x $@.tmp
	mv $@.tmp $@

build/gv-install: gv-install
	mkdir -p build
	rm -f $@ $@.tmp
	sed -e "1s@python@$(PYTHON_BASENAME)@" $< > $@.tmp
	chmod a-w,a+x $@.tmp
	mv $@.tmp $@

build/gvgit-get-keyids: gvgit-get-keyids
	mkdir -p build
	rm -f $@ $@.tmp
	sed -e "1s@python@$(PYTHON_BASENAME)@" $< > $@.tmp
	chmod a-w,a+x $@.tmp
	mv $@.tmp $@

install: all
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 build/gverify build/gvgit build/gv-install \
		$(DESTDIR)$(BINDIR)/
	install -d $(DESTDIR)$(GV_BINDIR)
	install -m 755 build/gvgit-get-keyids gvgit-gpg-wrapper \
		$(DESTDIR)$(GV_BINDIR)/

prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
builddir = $(REPODIR)/.build

build:
	swift build --disable-sandbox --build-path "$(builddir)"

install: build
	install -d "$(bindir)"
	install "$(builddir)/x86_64-apple-macosx/debug/requirements" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/requirements"

clean:
	rm -rf .build

.PHONY: build install uninstall clean

prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
builddir = .build

build:
	swift build --disable-sandbox

install: build
	install "$(builddir)/x86_64-apple-macosx/debug/requirements" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/requirements"

clean:
	rm -rf .build

.PHONY: build install uninstall clean

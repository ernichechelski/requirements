SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: requirements

swift-highlight: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

.PHONY: install
install: requirements
	@install -d "$(bindir)"
	@install "$(BUILDDIR)/release/requirements" "$(bindir)"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/requirements"

.PHONY: clean
distclean:
	@rm -f $(BUILDDIR)/release

.PHONY: clean
clean: distclean
	@rm -rf $(BUILDDIR)
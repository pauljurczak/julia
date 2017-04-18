## this is a simple wrapper just to forward on known commands to the
## embedding example with values pulled from Make.inc
SRCDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
JULIAHOME := $(abspath $(SRCDIR)/..)
BUILDDIR := .
include $(JULIAHOME)/Make.inc

release: # default target
all: release debug

embedding-args := \
	-C $(BUILDROOT)/examples/embedding \
	JULIA='$(JULIA_EXECUTABLE)' BIN='$(build_libexecdir)' \
	SPAWN='$(value spawn)' CC='$(CC)'

release debug:
	@$(MAKE) $@ $(embedding-args)

eprint-%:
	@$(MAKE) print-$* $(embedding-args)

clean:
	@$(MAKE) clean $(embedding-args)

.PHONY: all release debug clean eprint-*

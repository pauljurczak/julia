# This Makefile template requires the following variables to be set
# in the environment or on the command-line:
#   JULIA: path to julia[.exe] executable
#   BIN:   binary build directory

ifndef JULIA
  $(error "Please pass JULIA=[path of target julia binary], or set as environment variable!")
endif
ifndef BIN
  $(error "Please pass BIN=[path of build directory], or set as environment variable!")
endif

#=============================================================================
SPAWN ?= $1

# this source directory where embedding.c is located
SRCDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# get the executable suffix, if any
EXE := $(suffix $(abspath $(JULIA)))

# get compiler and linker flags. (see: `contrib/julia-config.jl`)
JULIA_CONFIG := $(JULIA) -e 'include(joinpath(JULIA_HOME, Base.DATAROOTDIR, "julia", "julia-config.jl"))' --
CPPFLAGS-add :=
CFLAGS-add = $(shell $(call SPAWN,$(JULIA_CONFIG) --cflags))
LDFLAGS-add = -lm $(shell $(call SPAWN,$(JULIA_CONFIG) --ldflags --ldlibs))

DEBUGFLAGS += -g

#=============================================================================

release: $(BIN)/embedding$(EXE)
debug:   $(BIN)/embedding-debug$(EXE)

$(BIN)/embedding$(EXE): $(SRCDIR)/embedding.c
	$(CC) $^ -o $@ $(CPPFLAGS-add) $(CPPFLAGS) $(CFLAGS-add) $(CFLAGS) $(LDFLAGS-add) $(LDFLAGS)

$(BIN)/embedding-debug$(EXE): $(SRCDIR)/embedding.c
	$(CC) $^ -o $@ $(CPPFLAGS-add) $(CPPFLAGS) $(CFLAGS-add) $(CFLAGS) $(LDFLAGS-add) $(LDFLAGS) $(DEBUGFLAGS)

clean:
	-rm -f $(BIN)/embedding-debug$(EXE) $(BIN)/embedding$(EXE)

.PHONY: release debug clean

# Makefile debugging trick:
# call print-VARIABLE to see the runtime value of any variable
print-%:
	@echo '$*=$($*)'

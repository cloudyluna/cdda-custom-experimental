NIX = nix
NIX_FORMATTER = nixfmt
SOURCES = $(shell find . -name "*.nix")
TARGET ?= .\#default

.PHONY: all build format check

all: format build

build: $(SOURCES)
	$(NIX) build --refresh $(TARGET)

run: $(SOURCES) 
	$(NIX) run --refresh $(TARGET)

install: ./result/
	$(NIX) profile install $(TARGET)

format: $(SOURCES)
	$(NIX_FORMATTER) $(SOURCES)

# NOTE: Make sure to commit/stash your current git tree if you
# encounter weird missing files issue.
check: $(SOURCES)
	$(NIX) flake check


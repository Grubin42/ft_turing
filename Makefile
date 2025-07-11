.PHONY: all build install uninstall clean deps

all: deps build

deps:
	opam install . --deps-only --yes

build:
	dune build

install:
	dune install

uninstall:
	dune uninstall

clean:
	dune clean

run:
	dune exec ft_turing -- $(ARGS)
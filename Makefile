build:
	ocaml pkg/build.ml native=true native-dynlink=true

clean:
	ocamlbuild -clean

.PHONY: build clean

VERSION      = $(shell opam query --version)
NAME_VERSION = $(shell opam query --name-version)
ARCHIVE      = $(shell opam query --archive)

release:
	git tag -a v$(VERSION) -m "Version $(VERSION)."
	git push origin v$(VERSION)
	opam publish prepare $(NAME_VERSION) $(ARCHIVE)
	opam publish submit $(NAME_VERSION)

.PHONY: release

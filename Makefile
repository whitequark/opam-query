build:
	ocaml pkg/build.ml native=true native-dynlink=true

clean:
	ocamlbuild -clean

.PHONY: build clean

VERSION = $(opam query --version)
NAME_VERSION = $(opam query --name-version)

release:
	git tag -a v$(VERSION) -m "Version $(VERSION)."
	git push origin v$(VERSION)
	opam publish prepare $(NAME_VERSION) $(opam query --archive)
	opam publish submit $(NAME_VERSION)

.PHONY: release

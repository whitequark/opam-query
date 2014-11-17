opam-query
==========

_opam-query_ is a tool that allows querying the OPAM package description
files from shell scripts, similar to `oasis query`.

Installation
------------

_opam-query_ can be installed via [OPAM](https://opam.ocaml.org):

    $ opam install opam-query

Usage
-----

_opam-query_ reads the OPAM package description from the provided filename
(`opam` from the current directory by default) and prints the requested fields,
one per line.

  * `--name`, `--version` and `--dev-repo` print the value of the correponding field.
  * `--maintainer`, `--author`, `--homepage`, `--bug-report` and `--license` print
    the values of the correponding field, concatenated by <code>, </code>.
  * `--tags` prints the values of the `tags:` field, concatenated by ` `.
  * `--name-version` prints the values of `name:` and `version:`, concatenated by `.`.
  * `--archive` will attempt to determine a public download URL based on the value
    of `dev-repo:` and `version:` fields. Currently, only GitHub is supported.

Automating opam releases
------------------------

_opam-query_ can be used together with [_opam-publish_](https://github.com/AltGr/opam-publish)
to automate the process of releasing OPAM packages. For example, if you have a `Makefile`
and are using GitHub, the following snippet will require nothing more than modifying
the `version:` field and running `make release`.

``` make
VERSION      = $(shell opam query --version)
NAME_VERSION = $(shell opam query --name-version)
ARCHIVE      = $(shell opam query --archive)

release:
  git tag -a v$(VERSION) -m "Version $(VERSION)."
  git push origin v$(VERSION)
  opam publish prepare $(NAME_VERSION) $(ARCHIVE)
  opam publish submit $(NAME_VERSION)
  rm -rf $(NAME_VERSION)

.PHONY: release
```

License
-------

_opam-query_ is distributed under the terms of [MIT license](LICENSE.txt).

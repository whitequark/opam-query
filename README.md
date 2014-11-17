opam-query
==========

_opam-query_ is a tool that allows querying the `opam` files from shell scripts,
similar to `oasis query`.

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

License
-------

_opam-query_ is distributed under the terms of [MIT license](LICENSE.txt).

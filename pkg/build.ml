#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg.ml"

let builder =
  `Other ("ocamlbuild -use-ocamlfind -classic-display " ^
          "-plugin-tags 'package(opam-lib),package(cppo_ocamlbuild)'", "_build")

let () =
  Pkg.describe "opam-query" ~builder [
    Pkg.bin ~auto:true "src/opam_query" ~dst:"opam-query";
    Pkg.doc "README.md";
    Pkg.doc "LICENSE.txt";
    Pkg.doc "CHANGELOG.md"; ]

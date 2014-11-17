open Ocamlbuild_plugin

let () =
  dispatch (fun hook ->
    Ocamlbuild_cppo.dispatcher hook;
    hook |> function
    | After_rules ->

      let opam = OpamFilename.of_string "opam" |> OpamFile.OPAM.read in
      let version = OpamFile.OPAM.version opam |> OpamPackage.Version.to_string in
      let bug_reports = match OpamFile.OPAM.bug_reports opam with [x] -> x | _ -> assert false in

      let descr = OpamFilename.of_string "descr" |> OpamFile.Descr.read in
      let synopsis = descr |> OpamFile.Descr.synopsis in

      flag ["cppo"] & S[A"-D"; A("VERSION " ^ version)];
      flag ["cppo"] & S[A"-D"; A("BUG_REPORTS " ^ bug_reports)];
      flag ["cppo"] & S[A"-D"; A("SYNOPSIS " ^ synopsis)]
    | _ -> ())

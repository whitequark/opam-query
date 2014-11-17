let opam_name opam =
  opam |> OpamFile.OPAM.name |> OpamPackage.Name.to_string

let opam_version opam =
  opam |> OpamFile.OPAM.version |> OpamPackage.Version.to_string

let guess_archive opam =
  match OpamFile.OPAM.dev_repo opam with
  | None -> failwith "No `dev-repo:' field was defined."
  | Some dev_repo ->
    let uri = dev_repo |> OpamTypesBase.string_of_pin_option |> Uri.of_string in
    match Uri.host uri with
    | Some "github.com" ->
      begin match Uri.path uri |> CCString.Split.list_cpy ~by:"/" with
      | _ :: username :: project :: _ ->
        Printf.sprintf "https://github.com/%s/%s/archive/v%s.tar.gz"
          username project (opam_version opam)
      | _ -> failwith "Unrecognized GitHub URL format."
      end
    | _ -> failwith "Unrecognized host specified in `dev-repo:' field."

let main field_flags filename =
  let opam = filename |> OpamFilename.of_string |> OpamFile.OPAM.read in
  try
    field_flags |> List.iter (fun fn ->
      fn opam |> print_endline);
    `Ok ()
  with Failure descr ->
    `Error (false, descr)

open Cmdliner

let field_flags =
  let field name fn = fn, Arg.info ~doc:("Print the value of the `" ^ name ^ ":' field.") [name] in
  let fields = [
    field "name"        opam_name;
    field "version"     opam_version;
    field "maintainer"  (fun x -> x |> OpamFile.OPAM.maintainer |> String.concat ", ");
    field "author"      (fun x -> x |> OpamFile.OPAM.author |> String.concat ", ");
    field "homepage"    (fun x -> x |> OpamFile.OPAM.homepage |> String.concat ", ");
    field "bug-reports" (fun x -> x |> OpamFile.OPAM.bug_reports |> String.concat ", ");
    field "dev-repo"    (fun x -> x |> OpamFile.OPAM.dev_repo |>
                          CCOpt.map OpamTypesBase.string_of_pin_option |>
                          CCOpt.get "");
    field "license"     (fun x -> x |> OpamFile.OPAM.license |> String.concat ", ");
    field "tags"        (fun x -> x |> OpamFile.OPAM.tags |> String.concat " ");
  ] in
  let name_version =
    (fun opam -> opam_name opam ^ "." ^ opam_version opam),
    Arg.info ~doc:"Print the values of `name:' and `version:' fields separated by a dot."
      ["name-version"]
  and archive =
    guess_archive,
    Arg.info ~doc:("Print the URL of a publicly downloadable source archive based on " ^
                   "the values of the `dev-repo:' and `version:' fields.")
      ["archive"]
  in
  Arg.(value & vflag_all [] (fields @ [name_version; archive]))

let filename =
  Arg.(value & pos 0 non_dir_file "opam" &
       info ~docv:"OPAM-FILE" ~doc:"Path to the opam file." [])

let main_t = Term.(ret (pure main $ field_flags $ filename))

let info =
  let doc = STRINGIFY(SYNOPSIS) in
  let man = [
    `S "BUGS";
    `P ("Report bugs at " ^ STRINGIFY(BUG_REPORTS) ^ ".");
  ] in
  Term.info "opam-query" ~doc ~man

let () = match Term.eval (main_t, info) with `Error _ -> exit 1 | _ -> exit 0

let ocamlVersion =
  (* show ocaml version as string *)
  Sys.ocaml_version |> Printf.sprintf "OCaml %s"

let render =
  let open Tyxml.Html in
  Default.base
    ~titles:"fahmiirsyadk"
    ~description:
      "FAHMIIRSYADK is a personal/blog website authored by fahmi irsyad khairi"
    ~canonical:""
  @@
  main ~a:[ a_class [ "flex items-start justify-center min-h-screen" ] ] 
  [
    h1 ~a:[ a_class [ "text-4xl font-bold text-neutral-900" ] ] [ txt "Hello, World!" ];
  ]
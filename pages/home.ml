let page =
  let open Dream_html in
  let open HTML in
    null [
      h1 [] [txt "Hello, World!"];
      p [] [ txt "%s" Sys.ocaml_version ];
    ]

 let render = Dream_html.respond (Default.base ~titles:"fahmiirsyadk" page)
  (* let open Tyxml.Html in
  Default.base
    ~titles:"fahmiirsyadk"
    ~description:
      "FAHMIIRSYADK is a personal/blog website authored by fahmi irsyad khairi"
    ~canonical:""
  @@
  main ~a:[ a_class [ "flex items-start justify-center min-h-screen" ] ] 
  [
    h1 ~a:[ a_class [ "text-4xl font-bold text-neutral-900" ] ] [ txt "Hello, World!" ];
  ] *)
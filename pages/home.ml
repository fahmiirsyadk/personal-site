let page =
  let open Dream_html in
  let open HTML in
  null
    [
      h1
        [ class_ "text-4xl font-bold text-red-400 text-center" ]
        [ txt "Hello, World! %s" Sys.ocaml_version ];
    ]

let render = Default.base ~titles:"fahmiirsyadk" page

let page =
  let open Dream_html in
  let open HTML in
  null
    [
      h1
        [ class_ "text-4xl font-bold text-red-400 text-center" ]
        [ txt "Hello, World! %s" Sys.ocaml_version ];
    ]

let blog list_blog =
  let open Dream_html in
  let open HTML in
  let list_blog = List.map (fun x ->
    li [ class_ "text-2xl font-bold text-red-400 text-center" ] [ txt x ]
  ) list_blog in
  null
    [
      h1
        [ class_ "text-4xl font-bold text-red-400 text-center" ]
        [ txt "Hello, World! %s" Sys.ocaml_version ];
      ul [] list_blog;
    ]

let render = Default.base ~titles:"fahmiirsyadk" page
let render_list list_blog = Default.base ~titles:"fahmiirsyadk" (blog list_blog)

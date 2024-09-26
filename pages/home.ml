let page =
  let open Dream_html in
  let open HTML in
  null
    [
      h1
        [ class_ "text-4xl font-bold text-red-400 text-center" ]
        [ txt "Hello, There! %s" Sys.ocaml_version ];
    ]

let rec elements =
  let open Dream_html in
  let open HTML in
  function
  | [] -> []
  | x :: xs ->
    li [ ]
    [ a [ href {|blog/%s|} x ] [ txt "%s" x ] ] :: elements xs

let blog (list_blog: string list) =
  let open Dream_html in
  let open HTML in
  div
    [ class_ "container mx-auto" ]
    [
      h1 [ class_ "text-4xl font-bold text-red-400 text-center" ] [ txt "Blog" ];
      h1
        [ class_ "text-4xl font-bold text-red-400 text-center" ]
        [ txt "Hello, There! %s" Sys.ocaml_version ];
      ul [ class_ "text-2xl font-bold text-red-400 text-center mt-16" ] (elements list_blog);
    ]

let render = Default.base ~titles:"fahmiirsyadk" page
let render_list data = Default.base ~titles:"fahmiirsyadk" (blog data)
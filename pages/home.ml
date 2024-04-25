let page =
  let open Dream_html in
  let open HTML in
  null
    [
      h1
        [ class_ "text-4xl font-bold text-red-400 text-center" ]
        [ txt "Hello, World! %s" Sys.ocaml_version ];
    ]

let rec elements =
  let open Dream_html in
  let open HTML in
  function
  | [] -> []
  | x :: xs -> li [] [ a [ href {|blog/%s|} x ] [ txt "%s" x ] ] :: elements xs

let blog (list_blog: string list) =
  let open Dream_html in
  let open HTML in
  div
    [ class_ "container mx-auto" ]
    [
      h1 [ class_ "text-4xl font-bold text-red-400 text-center" ] [ txt "Blog" ];
      ul [] (elements list_blog);
    ]

let render = Default.base ~titles:"fahmiirsyadk" page
let render_list list_blog = Default.base ~titles:"fahmiirsyadk" (blog list_blog)

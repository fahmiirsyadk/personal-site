let page =
  let open Dream_html in
  let open HTML in
    null [
      h1 [
        class_ "text-4xl font-bold text-neutral-900 text-center";
      ] [txt "Hello, World! mkdir test LWT 4"];
      p [] [ txt "%s" Sys.ocaml_version ];
    ]

 let render = (Default.base ~titles:"fahmiirsyadk" page)
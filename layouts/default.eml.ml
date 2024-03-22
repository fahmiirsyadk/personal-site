let base ~titles ?description ?canonical inner =
  let open Tyxml.Html in
  html
    (head
      (title (txt( "Fahmiirsyadk | " ^ titles)))
      [
        meta ~a:[ a_charset "utf-8" ] ();
        meta
          ~a:
            [
              a_name "viewport";
              a_content "width=device-width, initial-scale=1, shrink-to-fit=no";
            ]
          ();
        meta ~a:[ a_name "twitter:title"; a_content titles ] ();
        meta ~a:[ a_property "og:site_name"; a_content "fahmiirsyadk" ] ();
        meta ~a:[ a_property "og:type"; a_content "object" ] ();
        meta ~a:[ a_property "og:title"; a_content titles ] ();
        meta ~a:[ a_name "theme-color"; a_content "#fff" ] ();
        meta ~a:[ a_name "color-scheme"; a_content "white" ] ();
         (match description with
         | Some description ->
             meta ~a:[ a_name "description"; a_content description ] ()
         | None -> meta ~a:[ a_name "description"; a_content "" ] ());
         (match canonical with
         | Some canonical ->
             link ~rel:[ `Canonical ]
               ~href:("https://faahme.fly.dev" ^ canonical)
               ()
         | None -> link ~rel:[ `Canonical ] ~href:"https://faahme.fly.dev" ());
       ])
    (body [inner]) |> Format.asprintf "%a" (pp ())

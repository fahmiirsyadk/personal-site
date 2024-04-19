(* custom property tag for meta OG with type 'a string_attribute *)
let property fmt = Dream_html.string_attr "property" fmt

let base ~titles ?description ?cannonical inner =
  let open Dream_html in
  let open HTML in
  html []
    [
      head
        [ lang "id" ]
        [
          title [] "%s | Fahmiirsyadk" titles;
          meta [ charset "utf-8" ];
          meta
            [
              name "viewport";
              content "width=device-width, initial-scale=1, shrink-to-fit=no";
            ];
          meta [ name "twitter:title"; content "%s" titles ];
          meta [ property "og:site_name"; content "fahmiirsyadk" ];
          meta [ property "og:type"; content "object" ];
          meta [ property "og:title"; content "%s" titles ];
          meta [ name "theme-color"; content "#fff" ];
          meta [ name "color-scheme"; content "white" ];
          script [ src "https://cdn.tailwindcss.com" ] "";
          (match description with
          | Some description -> meta [ name "description"; content description ]
          | None -> null []);
          (match cannonical with
          | Some cannonical ->
              link
                [ rel "canonical"; href "https://faahme.fly.dev/%s" cannonical ]
          | None -> link [ rel "canonical"; href "https://faahme.fly.dev" ]);
        ];
      body [] [ inner ];
    ]

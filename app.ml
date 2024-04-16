let run routes =
  Dream.run ~interface:"0.0.0.0" @@ Dream.logger @@ Dream.router
    (Seele.process_route routes)

let routes = [ ("/", Home.render); ("static", Dream_html.HTML.null []) ]

let main () =
  if Seele.is_env_dev then
    run routes
  else
    Lwt_main.run (Seele.export_to_html routes)

let () = main ()
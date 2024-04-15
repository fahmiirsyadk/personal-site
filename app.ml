let run routes =
  Dream.run ~interface:"0.0.0.0" @@ Dream.logger @@ Dream.router
    (Seele.process_route routes)

let routes = [ ("/", Home.render); ("static", Dream_html.HTML.null []) ]

let main () =
  if Seele.is_env_prod then
    Lwt_main.run (Seele.export_to_html routes)
  else
    run routes

let () = main ()
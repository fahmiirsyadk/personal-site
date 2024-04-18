let run routes ?stop_condition () =
  match stop_condition with
  | None ->
     Dream.run ~interface:"0.0.0.0"
     @@ Dream.logger
     @@ Dream.router (Seele.process_route routes)
  | Some condition ->
     Dream.run ~interface:"0.0.0.0" ~stop:condition
     @@ Dream.logger
     @@ Dream.router (Seele.process_route routes)
 
 let routes =
  [
     ("/", Home.render);
     ("blog/something", Home.render);
     ("blog/reborn", Home.render);
     ("static", Dream_html.HTML.null []);
  ]
 
 let () =
  if Seele.is_env_dev then
     run routes ()
  else
     run routes ~stop_condition:(Seele.export_to_html routes) ()
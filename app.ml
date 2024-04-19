let run routes ?stop_condition () =
  match stop_condition with
  | None ->
      Dream.run ~interface:"0.0.0.0"
      @@ Dream.logger
      @@ Dream.router (Seele.process_route routes)
  | Some condition ->
      Dream.run ~interface:"0.0.0.0" ~stop:condition
      @@ Dream.router (Seele.process_route routes)

let routes =
  [
    ("/", `Static Home.render);
    ( "/blog/reborn",
      `Dynamic (fun _ -> Dream.respond "This is how i rebuilt my site") );
    ("static", `Exclude (Dream.get "/static/**" @@ Dream.static "static"));
  ]

let () =
  if Seele.is_env_dev then run routes ()
  else run routes ~stop_condition:(Seele.export_to_html routes) ()

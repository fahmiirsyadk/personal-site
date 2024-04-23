let run routes ?stop_condition () =
  match stop_condition with
  | None ->
      Dream.run ~interface:"0.0.0.0"
      @@ Dream.logger
      @@ Dream.router (Seele.process_route routes)
  | Some condition ->
      Dream.run ~interface:"0.0.0.0" ~stop:condition
      @@ Dream.router (Seele.process_route routes)

let dynamic_route request =
  let%lwt markdown_contents = Seele.load_markdown_file request "data/blog" in
  let (_, content) = markdown_contents in
  Dream.html (Seele.markdown_to_html content)

let routes =
  [
    ("/", `Static Home.render);
    ( "/blog/:word",
      `Dynamic (fun request -> Dream.param request "word" |> dynamic_route));
    ("static", `Exclude (Dream.get "/static/**" @@ Dream.static "static"));
  ]

let () =
  if Seele.is_env_dev then run routes ()
  else run routes ~stop_condition:(Seele.export_to_html routes) ()

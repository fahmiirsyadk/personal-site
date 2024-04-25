let dynamic_markdown request =
  let%lwt markdown_contents = Seele.Core.load_markdown_file request "data/blog" in
  let _, content = markdown_contents in
  Dream.html (Seele.Core.markdown_to_html content)

let list_blog = Seele.Core.list_markdown_files "data/blog"

let routes =
  [
    ("/", `Static (Home.render_list list_blog));
    ( "/blog/:word",
      `Dynamic
        ((fun request -> Dream.param request "word" |> dynamic_markdown), list_blog)
    );
    ("/about", `Static Home.render);
    ("static", `Exclude (Dream.get "/static/**" @@ Dream.static "static"));
  ]

let run routes ?stop_condition () =
  match stop_condition with
  | None ->
      Dream.run ~interface:"0.0.0.0"
      @@ Dream.logger
      @@ Dream.router (Seele.Core.process_route routes)
  | Some condition ->
      Dream.run ~interface:"0.0.0.0" ~stop:condition
      @@ Dream.router (Seele.Core.process_route routes)

let () =
  match Seele.Config.env with
  | Seele.Config.Dev -> run routes ()
  | Seele.Config.Prod -> run routes ~stop_condition:(Seele.export_static routes ()) ()
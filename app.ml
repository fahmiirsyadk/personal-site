open Seele.Core

let () =
  init_cache "data/blog";
  let list_blog = Seele.Core.list_markdown_files () in
  let blog_markdown  = List.map (fun (filename, _) -> filename) (list_blog) in

  let routes =
    [
      ("/", `Static (Home.render_list blog_markdown));
      ("/blog/:word", `Blog ((fun request ->
        let word = Dream.param request "word" in
        let%lwt entry = load_markdown_file word in
        let content_html = markdown_to_html entry.content in
        Dream.html (markdown_to_html content_html)), blog_markdown ));
      ("static", `Exclude (Dream.get "/static/**" @@ Dream.static "static"));
    ]
  in

  let run routes ?stop_condition () =
    match stop_condition with
    | None ->
        Dream.run ~interface:"0.0.0.0"
        @@ Dream.logger
        @@ Dream.router (process_route routes)
    | Some condition ->
        Dream.run ~interface:"0.0.0.0" ~stop:condition
        @@ Dream.router (process_route routes)
  in

  match Seele.Config.env with
  | Seele.Config.Dev -> run routes ()
  | Seele.Config.Prod ->
    run routes ~stop_condition:(Seele.export_static routes ()) ()
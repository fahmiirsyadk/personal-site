
let run routes () = 
  Dream.run
  ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream.router (Seele.process_route routes)
      (* [
       Dream.get "/" (fun _ -> (handle_request "index" Home.page));
       Dream.get "/static/**" @@ Dream.static "static";
       (* Dream.get "/:word" (fun request ->
          Dream.param request "word" |> Template.render |> Dream.html); *)
  ] *)
  
let routes = [ ("/", Home.render); ("static", Dream_html.HTML.null []) ]

let () =
  let _ = Seele.export_to_html routes in
  run routes ()
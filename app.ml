let () =
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html Home.render);
    Dream.get "/static/**" @@ Dream.static "static";
    (* Dream.get "/:word" (fun request ->
      Dream.param request "word"
      |> Template.render
      |> Dream.html); *)
  ]
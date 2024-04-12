let process_route routes =
  (List.map (fun (route, handler) -> 
    match route with 
    | "static" -> Dream.get "/static/**" @@ Dream.static "static"; (** Static files *)
    | _ -> Dream.get route (fun _ -> (Dream_html.respond handler))
    
) routes)

let export_to_html routes =
  let _ = Printf.printf "Exporting to HTML\n" in
  let export_route (route, handler) =
    let html = Dream_html.to_string (handler) in
    let outputFolder = "output" in
    let%lwt () = try
      Lwt_unix.mkdir outputFolder 0o755
    with
    | Unix.Unix_error (Unix.EEXIST, _, _) -> Lwt.return ()
    | Unix.Unix_error (Unix.EACCES, _, _) -> Printf.printf "Error: Permission denied\n" |> Lwt.return
    | _ -> Printf.printf "Unknown error\n" |> Lwt.return
    in
    let filename = match route with
      | "/" -> outputFolder ^ "/index.html"
      | _ -> outputFolder ^ "/" ^ route ^ ".html"
    in
    try
      Lwt_io.with_file
        ~mode:Lwt_io.Output
        ~flags:[ Unix.O_CREAT; Unix.O_TRUNC; Unix.O_WRONLY; Unix.O_EXCL ]
        filename
        (fun channel -> Lwt_io.write channel html)
    with
    | Unix.Unix_error (Unix.EEXIST, _, _) -> Printf.printf "File already exists\n" |> Lwt.return
    | Sys_error err -> Printf.printf "Error: %s\n" err |> Lwt.return
    | _ -> Printf.printf "Unknown error\n" |> Lwt.return
  in
  Lwt_list.iter_s export_route routes
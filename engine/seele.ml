open Lwt.Syntax
open Lwt.Infix

let process_route routes =
  (List.map (fun (route, handler) -> 
    match route with 
    | "static" -> Dream.get "/static/**" @@ Dream.static "static"; (** Static files *)
    | _ -> Dream.get route (fun _ -> (Dream_html.respond handler))
    
) routes)

let export_to_html routes =
  let ouputFolder = "output" in
  let export_route (route, handler) =
    let filename =
      match route with
      | "/" -> ouputFolder ^ "/index.html"
      | _ -> ouputFolder ^ "/" ^ route ^ ".html"
    in
    let* folder_exists = Lwt_unix.file_exists ouputFolder in
    let* () =
      if not folder_exists then
        Lwt.catch (fun () -> Lwt_unix.mkdir ouputFolder 0o755)
          (function
            | Unix.Unix_error (Unix.EACCES, _, _) ->
                Lwt.return (Printf.printf "Error: Permission denied\n")
            | exn ->
                Lwt.return (Printf.printf "Unknown error: %s\n" (Printexc.to_string exn)))
      else
        Lwt.return_unit
    in
    Lwt_io.with_file ~mode:Output ~flags:[Unix.O_CREAT; Unix.O_TRUNC; Unix.O_WRONLY] filename
      (fun channel -> Lwt_io.write channel (Dream_html.to_string handler))
    >>= fun () -> Lwt.return_unit
  in
  Lwt_list.iter_p export_route routes
open Lwt.Syntax
open Lwt.Infix

module Config = struct
  type env = Dev | Prod

  let env =
    match Sys.getenv_opt "ENVIRONMENT" with
    | Some "dev" -> Dev
    | Some "prod" -> Prod
    | _ -> Dev
end

module Logger = struct
  let info msg =
    Logs.info (fun m -> m "%s" msg)

  let error msg exn =
    Logs.err (fun m -> m "%s: %s" msg (Printexc.to_string exn))
end

module Core = struct
  let fetch_url url =
    let open Cohttp in
    let open Cohttp_lwt_unix in
    let open Lwt in
    Client.get (Uri.of_string url) >>= fun (res, body) ->
    let code = res |> Response.status |> Code.code_of_status in
    let%lwt json = body |> Cohttp_lwt.Body.to_string in
    Lwt.return (code, json)

  let process_route routes =
    List.map
      (fun (route, types) ->
        match types with
        | `Static node -> Dream.get route (fun _ -> Dream_html.respond node)
        | `Dynamic (handler, _) -> Dream.get route handler
        | `Exclude route -> route)
      routes

  let rec mkdir_p path =
    let* exists = Lwt_unix.file_exists path in
    if exists then Lwt.return_unit
    else
      let* parent_exists = Lwt_unix.file_exists (Filename.dirname path) in
      if parent_exists then
        Lwt.catch
          (fun () -> Lwt_unix.mkdir path 0o755)
          (function
            | Unix.Unix_error (Unix.EEXIST, _, _) -> Lwt.return_unit
            | exn -> Lwt.fail exn)
      else
        let* () = mkdir_p (Filename.dirname path) in
        Lwt.catch
          (fun () -> Lwt_unix.mkdir path 0o755)
          (function
            | Unix.Unix_error (Unix.EEXIST, _, _) -> Lwt.return_unit
            | exn -> Lwt.fail exn)

  let export_to_html routes =
    let outputFolder = "dist" in
    let* () = mkdir_p outputFolder in
    let export_route (route, types) =
      match types with
      | `Exclude _ -> Lwt.return_unit
      | _ -> (
          let routeFolder =
            match route with
            | "/" | "/index.html" -> outputFolder
            | _ -> outputFolder ^ "/" ^ route
          in
          let filename = routeFolder ^ "/index.html" in
          match types with
          | `Static node ->
              let () = Logs.info (fun m -> m "Exporting %s" route) in
              let* () = mkdir_p routeFolder in
              Lwt_io.with_file ~mode:Lwt_io.Output
                ~flags:[ Unix.O_CREAT; Unix.O_TRUNC; Unix.O_WRONLY ] filename
                (fun channel ->
                  Lwt_io.write channel (Dream_html.to_string node))
              >>= fun () -> Lwt.return_unit
          | `Dynamic (_, list_blog) ->
              Lwt_list.iter_p
                (fun blog ->
                  let route =
                    Str.global_replace (Str.regexp_string ":word") blog route
                  in
                  let () = Logs.info (fun m -> m "Exporting %s" route) in
                  let filename = outputFolder ^ "/" ^ route ^ "/index.html" in
                  let* () = mkdir_p (outputFolder ^ route) in
                  let base_url = "http://localhost:8080" ^ route in
                  let%lwt code, json = fetch_url base_url in
                  if code = 200 then
                    Lwt_io.with_file ~mode:Lwt_io.Output
                      ~flags:[ Unix.O_CREAT; Unix.O_TRUNC; Unix.O_WRONLY ]
                      filename (fun channel -> Lwt_io.write channel json)
                    >>= fun () -> Lwt.return_unit
                  else Lwt.return_unit)
                list_blog
              >>= fun () -> Lwt.return_unit
          | `Exclude _ -> Lwt.return_unit)
    in
    Lwt_list.iter_p export_route routes >>= fun () ->
    let () = Logs.info (fun m -> m "Done | Exported to %s" outputFolder) in
    Lwt.return_unit

  let markdown_to_html str =
    let markdown_ast = Omd.of_string str in
    Omd.to_html markdown_ast

  let list_markdown_files dir =
    Sys.readdir dir |> Array.to_list
    |> List.filter_map (fun file ->
           if Filename.check_suffix file ".md" then
             Some (Filename.chop_extension file)
           else None)

  let load_markdown_file filename dir =
    let file = Filename.concat dir (filename ^ ".md") in
    Lwt.catch
      (fun () ->
        Lwt_io.with_file ~mode:Lwt_io.input file Lwt_io.read >|= fun content ->
        (filename, content))
      (fun _ -> Lwt.return (filename, ""))

end

let export_static routes () =
  let* () = Core.export_to_html routes in Lwt.return_unit


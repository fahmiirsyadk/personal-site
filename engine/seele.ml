open Lwt.Syntax
open Lwt.Infix

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
            let* () = mkdir_p (outputFolder ^ route) in
            Lwt_io.with_file ~mode:Output
              ~flags:[ Unix.O_CREAT; Unix.O_TRUNC; Unix.O_WRONLY ] filename
              (fun channel -> Lwt_io.write channel (Dream_html.to_string node))
            >>= fun () -> Lwt.return_unit
        | `Dynamic (_, _) ->
            let param = "reborn" in
            let route =
              Str.global_replace (Str.regexp_string ":word") param route
            in
            let base_url = "http://localhost:8080" ^ route in
            let filename = outputFolder ^ route ^ "/index.html" in
            let* () = mkdir_p (outputFolder ^ route) in
            let _ = Printf.printf "Base URL: %s\n" base_url in
            let%lwt content = fetch_url base_url in
            let code, json = content in
            if code = 200 then
              let _ = Printf.printf "Exporting %s\n" filename in
              let%lwt () =
                Lwt_io.with_file ~mode:Output
                  ~flags:[ Unix.O_CREAT; Unix.O_TRUNC; Unix.O_WRONLY ] filename
                  (fun channel -> Lwt_io.write channel json)
              in
              Lwt.return_unit
            else Lwt.return_unit
        | `Exclude _ -> Lwt.return_unit)
  in
  Lwt_list.iter_p export_route routes

let read_env_file () =
  let env_file = ".env" in
  if Sys.file_exists env_file then
    let lines =
      let ic = open_in env_file in
      let rec read_lines acc =
        try
          let line = input_line ic in
          if String.trim line = "" || String.get line 0 = '#' then
            read_lines acc
          else read_lines (line :: acc)
        with End_of_file ->
          close_in ic;
          List.rev acc
      in
      read_lines []
    in
    lines
  else []

let is_env_dev =
  let env_lines = read_env_file () in
  List.exists
    (fun line ->
      match String.split_on_char '=' line with
      | key :: value :: _ ->
          String.trim key = "DEV" && String.trim value = "true"
      | _ -> false)
    env_lines

let markdown_to_html str =
  let markdown_ast = Omd.of_string str in
  Omd.to_html markdown_ast

let list_markdown_files dir =
  let files = Sys.readdir dir in
  Array.to_list files
  |> List.filter (fun file -> Filename.check_suffix file ".md")
  |> List.map (fun file -> Filename.chop_extension file)

let load_markdown_file filename dir =
  let file = Filename.concat dir filename ^ ".md" in
  let%lwt content = Lwt_io.with_file ~mode:Lwt_io.input file Lwt_io.read in
  Lwt.return (Filename.chop_extension (Filename.basename file), content)

let print_markdown_contents contents =
  let print_content (filename, content) =
    let html_content = markdown_to_html content in
    (filename, html_content)
  in
  List.map print_content contents

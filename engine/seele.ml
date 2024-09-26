(* core.ml *)

open Lwt.Syntax
open Lwt.Infix

type metadata = {
  title : string;
  excerpt : string;
  date : string;
  tags : string list;
}

module Config = struct
  type env = Dev | Prod

  let env =
    match Sys.getenv_opt "ENVIRONMENT" with
    | Some "prod" -> Prod
    | _ -> Dev
end

module Core = struct
  type entry = { content : string; metadata : metadata option }

  let split_key_value line =
    match String.split_on_char ':' line with
    | [key; value] -> Some (String.trim key, String.trim (String.trim value))
    | _ -> None

  (* Function to parse frontmatter *)
  let parse_frontmatter content =
    let lines = String.split_on_char '\n' content in
    let rec parse_lines acc = function
      | "---" :: rest -> (List.rev acc, rest)
      | line :: rest ->
          (match split_key_value line with
          | Some kv -> parse_lines (kv :: acc) rest
          | None -> parse_lines acc rest)
      | [] -> (List.rev acc, [])
    in
    match lines with
    | "---" :: rest ->
        let frontmatter, content = parse_lines [] rest in
        Some (frontmatter, String.trim (String.concat "\n" content))
    | _ -> None

  (* Function to convert frontmatter to metadata *)
  let frontmatter_to_metadata frontmatter =
    let find_value key = List.assoc_opt key frontmatter in
    {
      title = Option.value (find_value "title") ~default:"";
      excerpt = Option.value (find_value "excerpt") ~default:"";
      date = Option.value (find_value "date") ~default:"";
      tags =
        match find_value "tags" with
        | Some tags ->
            Str.split (Str.regexp "[ \t]*,[ \t]*") (String.trim tags)
        | None -> []
    }

  let parse_entry input =
    match parse_frontmatter input with
    | Some (frontmatter, content) ->
        { content; metadata = Some (frontmatter_to_metadata frontmatter) }
    | None -> { content = input; metadata = None }

  let store = Hashtbl.create 50

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
        | `Blog (handler, _) -> Dream.get route handler
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

  let print_store () =
    Hashtbl.iter
      (fun key value ->
        let () = Logs.info (fun m -> m "Key: %s" key) in
        let () = Logs.info (fun m -> m "Value: %s" value.content) in
        match value.metadata with
        | Some md ->
            let () = Logs.info (fun m -> m "Title: %s" md.title) in
            let () = Logs.info (fun m -> m "Excerpt: %s" md.excerpt) in
            let () = Logs.info (fun m -> m "Date: %s" md.date) in
            let () =
              Logs.info (fun m -> m "Tags: %s" (String.concat ", " md.tags))
            in
            ()
        | None -> ())
      store

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
          | `Blog (_, list_blog) ->
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

    let log_metadata md =
      Printf.printf "Metadata - Title: %s\n" md.title;
      Printf.printf "Metadata - Excerpt: %s\n" md.excerpt;
      Printf.printf "Metadata - Date: %s\n" md.date;
      Printf.printf "Metadata - Tags: %s\n" (String.concat ", " md.tags)

  let init_cache dir =
    let files =
      Sys.readdir dir |> Array.to_list
      |> List.filter (fun file -> Filename.check_suffix file ".md")
    in
    let load_file file =
      let filename = Filename.chop_extension file in
      let path = Filename.concat dir file in
      let content = In_channel.with_open_bin path In_channel.input_all in
      let result = parse_entry content in
      let metadata =
        match result.metadata with
        | Some md -> Some { title = md.title; excerpt = md.excerpt; date = md.date; tags = md.tags }
        | None -> None
      in
      Hashtbl.add store filename { content = result.content; metadata }
    in
    List.iter load_file files

  let markdown_to_html str =
    let doc = Cmarkit.Doc.of_string str in
    let html = Cmarkit_html.of_doc ~safe:false doc in
    html

  let load_markdown_file filename =
    try Lwt.return (Hashtbl.find store filename)
    with Not_found -> Lwt.return { content = ""; metadata = None }

  let list_markdown_files () =
    Hashtbl.fold
      (fun filename entry acc ->
        let title =
          match entry.metadata with Some md -> md.title | None -> filename
        in
        (filename, title) :: acc)
      store []
end

let export_static routes () =
  let* () = Core.export_to_html routes in
  let list_markdown_files  = Core.list_markdown_files () in

  Printf.printf "List markdown files Seele: %s\n" (String.concat ", " (List.map (fun (_, title) -> title) list_markdown_files));
  Lwt.return_unit
#!/usr/bin/env utop
(** This script is for building Owl's API documentation.           *)
(** Liang Wang, Computer Lab, University of Cambridge, 2018.02.01. *)

#require "re.pcre"
#require "owl-top"


(* simple function to read in the content of a file *)
let get_content fname = Owl_io.read_file_string fname


(** given a file name, return its url on github *)
let fname_to_github_url fname =
  "https://github.com/ryanrhymes/owl/tree/master/src/" ^ fname


(** generate a timestamp string for current moment *)
let make_timestamp () =
  let ts = Unix.gettimeofday() in
  let tm = Unix.localtime ts in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d"
    (tm.Unix.tm_year + 1900) (tm.Unix.tm_mon + 1) tm.Unix.tm_mday
    tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec


(** given a function type string, convert it to github line url *)
let funloc_to_github_line fname fun_typ loc =
  let regstr = "^[ ]*val[ ]*(.+?)[\\s]+" in
  let regex = Re.Pcre.regexp regstr in
  let l = Re.all regex fun_typ |> Array.of_list in
  if Array.length l = 0 then None
  else
    let fun_name = Re.Group.get l.(0) 1 in
    if Hashtbl.mem loc fun_name = false then None
    else
      let lines = Hashtbl.find_all loc fun_name in
      if List.length lines > 1 then None
      else
        let line_num = List.nth lines 0 in
        Some (Printf.sprintf
          "https://github.com/ryanrhymes/owl/blob/master/src/%s#L%i"
        fname line_num)


(* parse module.txt to get a list of modules to generate api doc *)
let get_module_files fname =
  Owl_io.read_file fname |>
  Array.map (fun s ->
    let l = String.split_on_char '|' s in
    let sig_file = List.nth l 0 |> String.trim in
    let impl_file = List.nth l 1 |> String.trim in
    let module_name = List.nth l 2 |> String.trim in
    sig_file, impl_file, module_name
  )


(* extract sections for source file *)
let extract_sections s =
  let regstr = "\\(\\*\\*[ ]*\\{[ \\d]*(.+?)\\}[ ]*\\*\\)[ \n]*" in
  let regex = Re.Pcre.regexp ~flags:[`MULTILINE] regstr in
  let sec_head = Owl.Utils.Stack.make () in
  let sec_body = Owl.Utils.Stack.make () in

  Re.split_full regex s |> List.iter (function
    | `Delim x -> Owl.Utils.Stack.push sec_head (Re.Group.get x 1)
    | `Text x  -> Owl.Utils.Stack.push sec_body x
  );

  let sections = Owl.Utils.Stack.make () in
  let _head = Owl.Utils.Stack.to_array sec_head in
  let _body = Owl.Utils.Stack.to_array sec_body in
  Array.iteri (fun i head ->
    let body = _body.(i + 1) in
    Owl.Utils.Stack.push sections (head, body)
  ) _head;

  Owl.Utils.Stack.to_array sections


(* given a section, parse to retrieve api/type and save to a hashtbl *)
let parse_one_section regstr s =
  let apidoc = Owl.Utils.Stack.make () in
  let regex = Re.Pcre.regexp ~flags:[`MULTILINE] regstr in
  Re.all regex s |> List.iter (fun mc ->
    let _fun_typ = Re.Group.get mc 1 in
    let _fun_doc = Re.Group.get mc 2 in
    let _fun_tup = `Function (_fun_typ, _fun_doc) in
    Owl.Utils.Stack.push apidoc _fun_tup
  );
  Owl.Utils.Stack.to_array apidoc


(* given a mli, parse to retrieve api doc and save to a hashtbl *)
let parse_one_mli fname =
  let res0 = "^[\\s]*(type [\\S\\s]+?)\\(\\*\\*[\\s]*([\\S\\s]+?)[\\s]*\\*\\)[\\s]*?^[\\s]*$" in
  let res1 = "^[\\s]*(val .+?)[ \n]*\\(\\*\\*[ \n]*([\\S\\s]+?)[ \n]*\\*\\)" in
  let res2 = "^[\\s]*(exception [\\S\\s]+?)\\(\\*\\*[\\s]*([\\S\\s]+?)[\\s]*\\*\\)[\\s]*?^[\\s]*$" in

  let s = get_content fname in
  let sections = extract_sections s in

  if Array.length sections = 0 then (
    let typdoc = parse_one_section res0 s in
    let apidoc = parse_one_section res1 s in
    let exndoc = parse_one_section res2 s in
    Array.(append apidoc exndoc |> append typdoc)
  )
  else (
    Array.fold_left (fun acc (head, body) ->
      let typdoc = parse_one_section res0 body in
      let apidoc = parse_one_section res1 body in
      let exndoc = parse_one_section res2 body in
      Array.(append apidoc exndoc |> append typdoc) |>
      Array.append [| `Section head |] |>
      Array.append acc
    ) [||] sections;
  )


(** Extract function implementation from an ml file, return a hashtbl *)
let locate_functions src_root impl_file =
  let regs1 = "^[ ]*let[ ]*(.+?)[\\s]+" in
  let regs2 = "^[ ]*let[ ]*(.+?)[\\s]*$" in
  let regex1 = Re.Pcre.regexp regs1 in
  let regex2 = Re.Pcre.regexp regs2 in
  let impl = Hashtbl.create 512 in
  Array.iteri (fun i s ->
    Re.(all regex1 s) @ Re.(all regex2 s) |>
    List.iter (fun mc ->
      let _fun = Re.Group.get mc 1 in
      Hashtbl.add impl _fun (i + 1)
    );
  ) (Owl_io.read_file ~trim:false (src_root ^ impl_file));
  impl


(* dump the api doc to a rst file *)
let write_to_rst apidoc sig_file impl_file rst_file module_name funloc =
  let h = open_out rst_file in
  let sig_url = fname_to_github_url sig_file in
  let impl_url = fname_to_github_url impl_file in
  Printf.fprintf h "%s\n%s\n\n" module_name (String.make 79 '=');
  Printf.fprintf h "This document is auto-generated for Owl's APIs.\n";
  Printf.fprintf h "#%i entries have been extracted.\n\n" (Array.length apidoc);
  (* NOTE: I comment this out to avoid sync a lot of files every time PR. *)
  (* Printf.fprintf h "timestamp: %s\n\n" (make_timestamp ()); *)
  Printf.fprintf h "Github:\n`{Signature} <%s>`_ \n`{Implementation} <%s>`_\n\n\n\n" sig_url impl_url;

  Array.iter (function
    | `Section section_head -> (
        let len = String.length section_head in
        let line = String.make (max len 79) '-' in
        Printf.fprintf h "%s\n%s\n\n\n\n" section_head line;
      )
    | `Function (api, doc)  -> (
        Str.(global_replace (regexp "\n[ ]*") "\n    ") api |>
        Printf.fprintf h ".. code-block:: ocaml\n\n  %s\n\n";
        Printf.fprintf h "%s\n\n" doc;
        match funloc_to_github_line impl_file api funloc with
        | Some url -> Printf.fprintf h "`source code <%s>`__\n\n\n\n" url
        | None     -> ()
      )
  ) apidoc;

  close_out h


(* parse all the modules to extract docs *)
let parse_modules src_root dst_root modules =
  let h = open_out (dst_root ^ "index.rst") in
  let num_funs = ref 0 in

  let toc = Array.fold_left (fun acc (sig_file, impl_file, module_name) ->
    Owl_log.info "owl_doc: parsing %s ..." sig_file;
    let bname = Filename.(basename sig_file |> chop_extension) in
    let iname = src_root ^ sig_file in
    let oname = dst_root ^ bname ^ ".rst" in
    let alldoc = parse_one_mli iname in
    let funloc = locate_functions src_root impl_file in
    write_to_rst alldoc sig_file impl_file oname module_name funloc;

    num_funs := !num_funs + (Array.length alldoc);
    Printf.sprintf "%s  %s\n\n" acc bname;
  ) "" modules
  in

  Printf.fprintf h "%s\n%s\n\n" "Owl API Reference" (String.make 79 '=');
  Printf.fprintf h ".. toctree::\n  :maxdepth: 2\n  :caption: Modules: ";
  Printf.fprintf h "#%i entries extracted at %s\n\n%s" !num_funs (make_timestamp ()) toc;

  close_out h


let _ =
  Owl_log.info "owl_doc: start ...";
  let src_root = Sys.argv.(1) in
  let dst_root = Sys.argv.(2) in
  let module_file = Sys.argv.(3) in

  let module_list = get_module_files module_file in
  parse_modules src_root dst_root module_list;
  Owl_log.info "owl_doc: finished!"

#!/usr/bin/env ocaml
#use "topfind"
#require "topkg,astring"
open Topkg

let minisat = Conf.with_pkg ~default:false "minisat"
let picosat = Conf.with_pkg ~default:false "picosat"
let cryptominisat = Conf.with_pkg ~default:false "cryptominisat"

let mlpack ?cond name =  
  let dir = Fpath.dirname name in
  let base = Fpath.basename name in
  let parse contents =
    let lines = String.cuts ~sep:'\n' contents in
    let add_mod acc l =
      let m = String.trim @@ match String.cut ~sep:'#' l with
      | None -> l
      | Some (m, _ (* comment *)) -> m
      in
      if m = "" then acc else m :: acc
    in
    Ok (List.fold_left add_mod [] lines)
  in
  let modls = (* modules within the pack *)
    let name = Fpath.(dir // base ^ ".mlpack") in
    OS.File.read name >>= parse
  in
  let intf modls = (* install interfaces for modules in the library - .cmti/.mli *)
    Ok (List.map 
      (fun m ->
         let name = Fpath.(dir // Astring.String.Ascii.uncapitalize m) in
           Pkg.lib ?cond ~exts:Exts.(exts [".cmti"; ".mli"]) name
      ) modls)
  in
  let name = Fpath.(dir // base) in
  let pkg l = 
    let lib = 
      Pkg.lib ?cond 
        ~exts:Exts.(exts [".a"; ".cmi"; ".cma"; ".cmx"; ".cmxa"; ".cmxs"; ".cmti"]) 
        name 
    in
    Ok (lib :: l)
  in
  (modls >>= intf >>= pkg) |> Log.on_error_msg ~use:(fun () -> [])

let () =
  Pkg.describe "sattools" @@ fun c ->
    let minisat = Conf.value c minisat in
    let picosat = Conf.value c picosat in
    let cryptominisat = Conf.value c cryptominisat in
    Ok ( 
      mlpack "src/sattools" @
      [
        Pkg.clib ~cond:minisat "minisat/libominisat.clib";
        Pkg.mllib ~cond:minisat 
          ~api:["Minisat_bindings"; "Minisat"] "minisat/ominisat.mllib";
        
        Pkg.clib ~cond:picosat "picosat/libopicosat.clib";
        Pkg.mllib ~cond:picosat 
          ~api:["Picosat_bindings"; "Picosat"] "picosat/opicosat.mllib";
        
        Pkg.clib ~cond:cryptominisat "cryptominisat/libocryptominisat.clib";
        Pkg.mllib ~cond:cryptominisat 
          ~api:["Cryptominisat_bindings"; "Cryptominisat"] "cryptominisat/ocryptominisat.mllib";
      ])


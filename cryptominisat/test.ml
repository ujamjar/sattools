open Printf
open Cryptominisat

let s = create ()

let () = add_clause s [1;2]

let () = printf "%s\n" @@ Sattools.Lbool.to_string @@ solve s
let () = Array.iter (fun s -> printf "%s " @@ Sattools.Lbool.to_string s) @@ get_all_models s
let () = printf "\n"

let () = destroy s


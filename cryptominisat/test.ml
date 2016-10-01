open Printf
open Cryptominisat

let s = create ()

let () = add_clause s [1;2]

let () = printf "%s\n" @@ string_of_lbool @@ solve s
let () = Array.iter (fun s -> printf "%s " @@ string_of_lbool s) @@ get_all_models s
let () = printf "\n"

let () = destroy s


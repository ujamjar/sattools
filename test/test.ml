
let () = Printf.printf "available solvers:\n"
let () = List.iter (Printf.printf "%s\n") @@ Sattools.Libs.available_solvers ()


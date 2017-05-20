(* ocaml nqueens.ml 4 *)

let nqueens size = 

  (* generate rows/cols/diagonals *)

  let idx (r,c) = (r*size)+c+1 in

  let init n f = Array.to_list @@ Array.init n f in

  let row r = init size (fun c -> idx (r,c)) in

  let col c = init size (fun r -> idx (r,c)) in

  let rec diag1 (r,c) = 
    if r >= size || c >= size then []
    else idx (r,c) :: diag1 (r+1,c+1)
  in
  let rec diag2 (r,c) = 
    if r >= size || c < 0 then []
    else idx (r,c) :: diag2 (r+1,c-1)
  in

  (* generate contraints *)

  let at_most_one x = 
    let rec pairs = function
      | [] -> []
      | h :: [] -> []
      | h :: t ->
        let r = List.map (fun t -> [-h;-t]) t in
        r :: pairs t
    in
    List.concat (pairs x)
  in

  let only_one x = x :: at_most_one x in

  (* solve *)

  let open Sattools.Libs in
  let module Sat = (val (get_solver @@ List.hd @@ available_solvers())) in

  let sat = Sat.create () in

  let () = 
    let add = List.iter (Sat.add_clause sat) in
    for i=0 to size-1 do
      add @@ only_one (row i);
      add @@ only_one (col i);
      add @@ at_most_one (diag1 (i,0));
      add @@ at_most_one (diag1 (0,i)); 
      add @@ at_most_one (diag2 (i,size-1));
      add @@ at_most_one (diag2 (0,i));
    done
  in

  let open Printf in
  match Sat.solve_with_model sat with
  | `unsat -> printf "no solution\n"
  | `sat soln ->
    for r=0 to size-1 do
      for c=0 to size-1 do
        if List.mem (idx (r,c)) soln then printf "Q"
        else printf "."
      done;
      printf "\n"
    done

let () = nqueens (int_of_string Sys.argv.(1))


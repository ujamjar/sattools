(* ocaml sudoku.ml < puzzle.txt *)

#use "topfind";;
#require "sattools.minisat";;

(* contraints *)

module M = struct
    type 'a t = 'a list
    let (>>=) l f = List.concat (List.map f l)
    let return x =[x]
end

open M

let p r c v = (r*100) + (c*10) + v
let n r c v = (-(p r c v))
let rec r l h = if l>h then [] else l :: r (l+1) h

let one_in_each = 
  (r 1 9) >>= fun x -> 
  (r 1 9) >>= fun y -> 
    return ((r 1 9) >>= fun z -> 
              return (p x y z))

let once_in_row = 
  (r 1 9) >>= fun y -> 
  (r 1 9) >>= fun z -> 
  (r 1 8) >>= fun x -> 
  (r (x+1) 9) >>= fun i -> 
    return [n x y z; n i y z]

let once_in_col = 
  (r 1 9) >>= fun x -> 
  (r 1 9) >>= fun z -> 
  (r 1 8) >>= fun y -> 
  (r (y+1) 9) >>= fun i -> 
    return [n x y z; n x i z]

let once_in_block_1 = 
  (r 1 9) >>= fun z ->
  (r 0 2) >>= fun i ->
  (r 0 2) >>= fun j ->
  (r 1 3) >>= fun x ->
  (r 1 3) >>= fun y ->
  (r (y+1) 3) >>= fun k ->
    return [ n (3*i+x) (3*j+y) z; n (3*i+x) (3*j+k) z ]

let once_in_block_2 = 
  (r 1 9) >>= fun z ->
  (r 0 2) >>= fun i ->
  (r 0 2) >>= fun j ->
  (r 1 3) >>= fun x ->
  (r 1 3) >>= fun y ->
  (r (x+1) 3) >>= fun k ->
  (r 1 3) >>= fun l ->
    return [ n (3*i+x) (3*j+y) z; n (3*i+k) (3*j+l) z ]

(* read puzzle *)

(* create sat problem *)

open Sattools.Libs
module Sat = (val (get_solver @@ List.hd @@ available_solvers()))

let solve puzzle = 
  let open Printf in
  let sat = Sat.create () in
  let add = List.iter (Sat.add_clause sat) in
  let () = add one_in_each in
  let () = add once_in_row in
  let () = add once_in_col in
  let () = add once_in_block_1 in
  let () = add once_in_block_2 in
  let () = add puzzle in
  Sat.solve_with_model sat 

(* read sudoku puzzle *)

let rec read f = 
  let rec next () = 
    match f () with
    | '1' .. '9' as c -> Char.code c - Char.code '0'
    | '_' | '0' | '.' -> 0
    | _ -> next ()
  in
  ((r 1 9) >>= fun x -> (r 1 9) >>= fun y -> return (x,y)) 
  |> List.map (fun (x,y) -> x,y,next())
  |> List.filter (fun (_,_,v) -> v<>0)
  |> List.map (fun (x,y,v) -> [p x y v])

(* report results *)

let solution = function
  | `sat soln ->
    let soln = 
         soln
      |> List.filter ((<)0) 
      |> List.map (fun i -> (i/100, (i mod 100)/10), i mod 10) 
    in
    (r 1 9) >>= fun x -> return ((r 1 9) >>= fun y -> return (List.assoc (x,y) soln))
  | `unsat -> 
    failwith "no solution"

let print solution =
  let open Printf in
  List.iteri (fun i s -> 
      if i<>0 && i mod 3 = 0 then printf "\n";
      List.iteri (fun i x -> 
          if i<>0 && i mod 3 = 0 then printf " ";
          printf "%i" x;
        ) s;
      printf "\n"
    ) solution 

let puzzle = read (fun () -> input_char stdin)
let test () = print @@ solution @@ solve puzzle
let () = test ()


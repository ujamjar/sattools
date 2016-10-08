open Printf

module type Cnf = sig
  type t
  val iter : (int list -> unit) -> t -> unit
  val nvars : t -> int
  val nterms : t -> int
end

module IntList = struct

  type t = int list list

  let nvars terms =
    List.fold_left 
      (List.fold_left (fun mx v -> max mx (abs v))) 
      0 terms

  let nterms terms = List.length terms

  let iter = List.iter

end

module Make(Cnf : Cnf) = struct

  let write chan terms = 
    let nvars = Cnf.nvars terms in
    let nterms = Cnf.nterms terms in
    fprintf chan "p cnf %i %i\n" nvars nterms;
    let print_term t = List.iter (fprintf chan "%i ") t; fprintf chan "0\n" in
    Cnf.iter print_term terms

  let solver_name solver = 
    match solver with
    | "dimacs-crypto" -> "cryptominisat4_simple"
    | "dimacs-mini" -> "minisat"
    | "dimacs-pico" -> "picosat"
    | _ -> failwith ("unknown solver: " ^ solver)

  let run_solver solver fin fout = 
    let solver_name = solver_name solver in
    match solver with 
    | "dimacs-crypto" -> 
      ignore @@ Unix.system(sprintf "%s --verb=0 %s > %s" solver_name fin fout)
    | "dimacs-mini" -> 
      ignore @@ Unix.system(sprintf "%s -verb=0 %s %s > /dev/null 2>&1" solver_name fin fout)
    | "dimacs-pico" -> 
      ignore @@ Unix.system(sprintf "%s %s > %s" solver_name fin fout)
    | _ -> failwith ("unknown solver: " ^ solver)

  let with_out_file name fn = 
    let f = open_out name in
    let r = fn f in
    close_out f;
    r

  (* read output file *)
  let read_sat_result fout = 
    let f = open_in fout in
    let result = 
      try begin
        match input_line f with
        | "SATISFIABLE" | "SAT" | "s SATISFIABLE" -> `sat
        | "UNSATISFIABLE" | "UNSAT" | "s UNSATISFIABLE" -> `unsat
        | _ -> failwith "DIMACS bad output"
      end with _ -> failwith "DIMACS bad output"
    in
    if result = `sat then 
      let split_char sep str =
        let rec indices acc i =
          try
            let i = succ(String.index_from str i sep) in
            indices (i::acc) i
          with Not_found -> (String.length str + 1) :: acc
        in
        let is = indices [0] 0 in
        let rec aux acc = function
          | last::start::tl ->
              let w = String.sub str start (last-start-1) in
              aux (w::acc) (start::tl)
          | _ -> acc
        in
        aux [] is 
      in
      let rec read_result_lines () = 
        try begin
          let line = input_line f in
          let tokens = List.filter ((<>) "") @@ split_char ' ' line in
          match tokens with
          | "v" :: tl -> List.map int_of_string tl :: read_result_lines ()
          | _ as l -> List.map int_of_string l :: read_result_lines ()
        end with _ ->
          []
      in
      let res = List.flatten @@ read_result_lines () in
      let () = close_in f in
      `sat res
    else 
      let () = close_in f in
      `unsat

  type 'a result = [ `unsat | `sat of 'a ]

  let run ?(solver="dimacs-mini") cnf = 
    let fin = Filename.temp_file "sat_cnf_in" "hardcaml" in
    let fout = Filename.temp_file "sat_res_out" "hardcaml" in
    (* generate cfg file *)
    with_out_file fin (fun f -> write f cnf);
    (* run solver *)
    run_solver solver fin fout;
    (* parse result file *)
    let result = read_sat_result fout in
    (* delete the temporary files *)
    (try Unix.unlink fin with _ -> ());
    (try Unix.unlink fout with _ -> ());
    result

end

(* generic [int list list] based cnf interface *)
include Make(IntList)

(* generate interface libraries *)
module GenLib(X : sig 
    val solver : string
end) = struct
  include X
  type solver = 
    {
      mutable cnf : int list list;
      mutable model : int list;
    }
  let create () = { cnf = []; model = [] }
  let destroy t = (t.cnf <- []; t.model <- [])
  let add_clause t s = t.cnf <- s :: t.cnf
  let solve_with_model t = run ~solver:X.solver t.cnf
  let solve t = 
    match run ~solver:X.solver t.cnf with
    | `unsat -> `unsat
    | `sat x -> begin 
      t.model <- x;
      `sat ()
    end
  let model t x = 
    let x = abs x in
    if List.mem x t.model then `t
    else if List.mem (-x) t.model then `f
    else `u
end

let add_solver solver = 
  match Unix.system ("which " ^ solver_name solver ^ " > /dev/null") with
  | Unix.WEXITED 0 ->
    let module X = GenLib(struct let solver = solver end) in
    Libs.add_solver solver (module X : Libs.Solver)
  | _ -> ()

let () = add_solver "dimacs-pico" 
let () = add_solver "dimacs-mini" 
let () = add_solver "dimacs-crypto" 


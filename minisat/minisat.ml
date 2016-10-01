module F = Minisat_bindings.Bindings(Minisat_stubs)

exception Minisat_bad_result_value
exception Minisat_bad_clause

module L = struct

  module Vec = F.Vec

  (* low level interface *)
  let create = F.create
  let destroy = F.destroy
  let new_var = F.new_var
  let add_clause s x = if F.add_clause s x = 0 then raise Minisat_bad_clause else ()
  let solve t = Sattools.Lbool.of_int (F.solve t)
  let solve_with_assumptions t a = Sattools.Lbool.of_int (F.solve_with_assumptions t a)
  let simplify s = if F.simplify s = 0 then false else true
  let value_of s x = Sattools.Lbool.of_int @@ F.value_of s x
  let n_vars = F.n_vars
  let n_clauses = F.n_clauses
  let mem_use = F.mem_used
  let cpu_time = F.cpu_time

end

type t = 
  {
    solver : F.t;
    mutable num_vars : int;
    vec : L.Vec.t;
  }

exception Minisat_zero_literal

let create () = 
  let solver = L.create () in
  {
    solver;
    num_vars = 0;
    vec = L.Vec.create ();
  }

let destroy s = L.destroy s.solver

let vec_of_lits v l = 
  L.Vec.clear v;
  List.iter 
    (fun i ->
      let sgn = i < 0 in
      let i = abs i in
      if i = 0 then raise Minisat_zero_literal 
      else L.Vec.push v (i-1) sgn)
    l

let add_vars s c = 
  let max_var = List.fold_left 
    (fun m l -> 
      if l = 0 then raise Minisat_zero_literal
      else max m (abs l)) 
    s.num_vars c 
  in
  if max_var > s.num_vars then begin
    for i=s.num_vars to max_var-1 do
      L.new_var s.solver
    done;
    s.num_vars <- max_var;
  end

let add_clause s c = 
  (* add new variables if needed *)
  add_vars s c;
  vec_of_lits s.vec c;
  L.add_clause s.solver s.vec 

let solve ?(assumptions=[]) s = 
  match assumptions with
  | [] -> L.solve s.solver
  | _ ->
    vec_of_lits s.vec assumptions;
    L.solve_with_assumptions s.solver s.vec

let get_model s i = 
  if i=0 then raise Minisat_zero_literal
  else L.value_of s.solver (i-1)

let get_all_models s = 
  Array.init (s.num_vars+1) 
    (fun i -> if i=0 then `u else get_model s i)

module X = struct

  type solver = t
  let create = create
  let destroy = destroy
  let add_clause = add_clause
  let get_result s i = 
    match get_model s (i+1) with
    | `t -> (i+1)
    | `f -> -(i+1)
    | _ -> 0
  let solve s = 
    let r = solve s in
    match r with
    | `t -> `sat (Array.to_list @@ Array.init s.num_vars @@ get_result s)
    | `f -> `unsat
    | _ -> raise Minisat_bad_result_value

end

let () = Sattools.Libs.(add_solver "mini" (module X : Solver))


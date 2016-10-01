module F = Cryptominisat_bindings.Bindings(Cryptominisat_stubs)

exception Cryptominisat_bad_result_value

module L = struct

  module Vec = F.Vec

  (* low level interface *)
  (* min-1 = max *)
  let max_long = Signed.Long.(sub min_int (of_int 1))

  let create =
    (fun ?(verbose=0) ?(conflict_limit=max_long) ?(threads=1) () ->
      F.create verbose conflict_limit threads)
  let destroy = F.destroy

  let new_vars = F.new_vars
  let new_var = F.new_var

  let add_clause = F.add_clause
  let solve = (fun t -> Sattools.Lbool.of_int (F.solve t))
  let solve_with_assumptions = 
    (fun t a -> Sattools.Lbool.of_int (F.solve_with_assumptions t a))
  let get_model = 
    (fun t i -> Sattools.Lbool.of_int (F.get_model t i))

  let print_stats = F.print_stats

end

type t = 
  {
    solver : F.t;
    mutable num_vars : int;
    vec : L.Vec.t;
  }

exception Cryptominisat_zero_literal

let create ?verbose ?conflict_limit ?threads () = 
  let solver = L.create ?verbose ?conflict_limit ?threads () in
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
      if i = 0 then raise Cryptominisat_zero_literal 
      else L.Vec.push_back v (i-1) sgn)
    l

let add_vars s c = 
  let max_var = List.fold_left 
    (fun m l -> 
      if l = 0 then raise Cryptominisat_zero_literal
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
  if i=0 then raise Cryptominisat_zero_literal
  else L.get_model s.solver (i-1)

let get_all_models s = 
  Array.init (s.num_vars+1) 
    (fun i -> if i=0 then `u else get_model s i)

let print_stats s = L.print_stats s.solver

module X = struct

  type solver = t
  let create () = create ()
  let destroy = destroy
  let add_clause = add_clause
  let get_result s i = 
    match get_model s (i+1) with
    | `t -> (i+1)
    | `f -> -(i+1)
    | _ -> 0
  let solve_with_model s = 
    let r = solve s in
    match r with
    | `t -> `sat (Array.to_list @@ Array.init s.num_vars @@ get_result s)
    | `f -> `unsat
    | _ -> raise Cryptominisat_bad_result_value
  let solve s = 
    let r = solve s in
    match r with
    | `t -> `sat ()
    | `f -> `unsat
    | _ -> raise Cryptominisat_bad_result_value
  let model s i = get_model s i
end

let () = Sattools.Libs.(add_solver "crypto" (module X : Solver))


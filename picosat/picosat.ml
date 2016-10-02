module F = Picosat_bindings.Bindings(Picosat_stubs)

exception Picosat_bad_result_value
exception Picosat_solver_error

module L = struct

  let create = F.create
  let destroy = F.destroy

  let add s l = ignore @@ F.add s l
  let assume  = F.assume

  let solve t = 
    match F.solve t (-1) with
    | 0 -> `u 
    | 10 -> `t
    | 20 -> `f
    | _ -> raise Picosat_solver_error
  let deref s x = 
    match F.deref s x with
    | -1 -> `f
    | 1 -> `t
    | _ -> raise Picosat_bad_result_value
  let n_vars = F.n_vars
  let n_clauses = F.n_clauses

end

type t = 
  {
    solver : F.t;
    mutable num_vars : int;
  }

exception Picosat_zero_literal

let create () = 
  let solver = L.create () in
  {
    solver;
    num_vars = 0;
  }

let destroy s = L.destroy s.solver

let count_vars s c =
  let max_var = List.fold_left 
    (fun m l -> 
      if l = 0 then raise Picosat_zero_literal
      else max m (abs l)) 
    s.num_vars c 
  in
  s.num_vars <- max_var

let add_clause s c = 
  count_vars s c;
  List.iter (L.add s.solver) c; L.add s.solver 0

let solve ?(assumptions=[]) s = 
  count_vars s assumptions;
  List.iter (L.assume s.solver) assumptions;
  L.solve s.solver

let get_model s i = 
  if i=0 then raise Picosat_zero_literal
  else L.deref s.solver i

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
  let solve_with_model s = 
    let r = solve s in
    match r with
    | `t -> `sat (Array.to_list @@ Array.init s.num_vars @@ get_result s)
    | `f -> `unsat
    | _ -> raise Picosat_bad_result_value
  let solve s = 
    let r = solve s in
    match r with
    | `t -> `sat ()
    | `f -> `unsat
    | _ -> raise Picosat_bad_result_value
  let model s i = get_model s i
end

let () = Sattools.Libs.(add_solver "pico" (module X : Solver))


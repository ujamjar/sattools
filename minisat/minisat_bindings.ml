open Ctypes 

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  module Vec = struct
    (* literal clauses *)
    type vec_s
    let vec_s : vec_s structure typ = structure "vec"
    type t = vec_s structure ptr
    let t = ptr vec_s

    let create = foreign "minisat_stubs_vec_create" (void @-> returning t)
    let destroy = foreign "minisat_stubs_vec_destroy" (t @-> returning void)
    let clear = foreign "minisat_stubs_vec_clear" (t @-> returning void)
    let push = foreign "minisat_stubs_vec_push" (t @-> int @-> bool @-> returning void)
  end

  type sat_solver_s
  let sat_solver_s : sat_solver_s structure typ = structure "Solver"
  type t = sat_solver_s structure ptr
  let t = ptr sat_solver_s

  let create = foreign "minisat_stubs_new" (void @-> returning t) 
  let destroy = foreign "minisat_stubs_delete" (t @-> returning void)
  let new_var = foreign "minisat_stubs_new_var" (t @-> returning void)
  let add_clause = foreign "minisat_stubs_add_clause" (t @-> Vec.t @-> returning int)
  let simplify = foreign "minisat_stubs_simplify" (t @-> returning int)
  let solve = foreign "minisat_stubs_solve" (t @-> returning int) 
  let solve_with_assumptions = foreign "minisat_stubs_solve_with_assumptions" 
      (t @-> Vec.t @-> returning int) 
  let value_of = foreign "minisat_stubs_value_of" (t @-> int @-> returning int)
  let n_vars = foreign "minisat_stubs_n_vars" (t @-> returning int)
  let n_clauses = foreign "minisat_stubs_n_clauses" (t @-> returning int)
  let mem_used = foreign "minisat_stubs_mem_used" (void @-> returning double)
  let cpu_time = foreign "minisat_stubs_cpu_time" (void @-> returning double)

end


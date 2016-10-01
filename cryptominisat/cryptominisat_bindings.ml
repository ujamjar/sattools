open Ctypes 

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  module Vec = struct
    (* literal clauses *)
    type vec_s
    let vec_s : vec_s structure typ = structure "vec"
    type t = vec_s structure ptr
    let t = ptr vec_s

    let create = foreign "cryptominisat_stubs_vec_create" (void @-> returning t)
    let destroy = foreign "cryptominisat_stubs_vec_destroy" (t @-> returning void)
    let clear = foreign "cryptominisat_stubs_vec_clear" (t @-> returning void)
    let push_back = foreign "cryptominisat_stubs_vec_push_back" (t @-> int @-> bool @-> returning void)
  end

  type sat_solver_s
  let sat_solver_s : sat_solver_s structure typ = structure "SATSolver"
  type t = sat_solver_s structure ptr
  let t = ptr sat_solver_s

  let create = foreign "cryptominisat_stubs_create" (int @-> long @-> int @-> returning t) 
  let destroy = foreign "cryptominisat_stubs_destroy" (t @-> returning void)
  let new_vars = foreign "cryptominisat_stubs_new_vars" (t @-> int @-> returning void)
  let new_var = foreign "cryptominisat_stubs_new_var" (t @-> returning void)
  let add_clause = foreign "cryptominisat_stubs_add_clause" (t @-> Vec.t @-> returning void)
  let solve = foreign "cryptominisat_stubs_solve" (t @-> returning int) 
  let solve_with_assumptions = foreign "cryptominisat_stubs_solve_with_assumptions" (t @-> Vec.t @-> returning int) 
  let get_model = foreign "cryptominisat_stubs_get_model" (t @-> int @-> returning int) 
  let print_stats = foreign "cryptominisat_stubs_print_stats" (t @-> returning void)

end


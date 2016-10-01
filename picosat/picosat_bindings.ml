open Ctypes 

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  type sat_solver_s
  let sat_solver_s : sat_solver_s structure typ = structure "PicoSAT"
  type t = sat_solver_s structure ptr
  let t = ptr sat_solver_s

  let create = foreign "picosat_init" (void @-> returning t)
  let destroy = foreign "picosat_reset" (t @-> returning void)
  let add = foreign "picosat_add" (t @-> int @-> returning int)
  let assume = foreign "picosat_assume" (t @-> int @-> returning void)

  let n_vars = foreign "picosat_variables" (t @-> returning int)
  let n_clauses = foreign "picosat_added_original_clauses" (t @-> returning int)

  let solve = foreign "picosat_sat" (t @-> int @-> returning int)
  let deref = foreign "picosat_deref" (t @-> int @-> returning int)

  let push = foreign "picosat_push" (t @-> returning int)
  let pop = foreign "picosat_pop" (t @-> returning int)

end



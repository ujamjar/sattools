module type Solver = sig
  type solver
  val create : unit -> solver
  val destroy : solver -> unit
  val add_clause : solver -> int list -> unit
  val solve : solver -> unit Result.t
  val solve_with_model : solver -> int list Result.t
  val model : solver -> int -> Lbool.t
end

val add_solver : string -> (module Solver) -> unit
val get_solver : string -> (module Solver)
val available_solvers : unit -> string list


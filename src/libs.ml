module type Solver = sig
  type solver
  val create : unit -> solver
  val destroy : solver -> unit
  val add_clause : solver -> int list -> unit
  val solve : solver -> unit Result.t
  val solve_with_model : solver -> int list Result.t
  val model : solver -> int -> Lbool.t
end

let solvers : (string * (module Solver)) list ref = ref []

let add_solver name solver = solvers := (name,solver) :: !solvers

let get_solver name = List.assoc name !solvers

let available_solvers () = List.map fst !solvers


module Lbool : sig
  exception Invalid_lbool_int_value of int
  type t = [ `t | `f | `u ]
  val to_string : t -> string
  val of_int : int -> t
end

module Result : sig
  type 'a t = [ `unsat | `sat of 'a ]
end

module Solver : sig
  type t = [`pico|`mini|`crypto]
end

module Libs : sig

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

end


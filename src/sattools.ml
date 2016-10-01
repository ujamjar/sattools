module Lbool = struct
  exception Invalid_lbool_int_value of int
  type t = [ `t | `f | `u ]
  let to_string = function
    | `t -> "T"
    | `f -> "F"
    | `u -> "U"
  let of_int = function
    | 0 -> `f
    | 1 -> `t
    | 2 -> `u
    | x -> raise (Invalid_lbool_int_value x)
end

module Result = struct
  type 'a t = [ `unsat | `sat of 'a ]
end

module Solver = struct
  type t = [`pico|`mini|`crypto]
end

module Libs = struct

  module type Solver = sig
    type solver
    val create : unit -> solver
    val destroy : solver -> unit
    val add_clause : solver -> int list -> unit
    val solve : solver -> int list Result.t
  end

  let solvers : (string * (module Solver)) list ref = ref []

  let add_solver name solver = solvers := (name,solver) :: !solvers
  let get_solver name = List.assoc name !solvers
  let available_solvers () = List.map fst !solvers

end


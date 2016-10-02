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


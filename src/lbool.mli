exception Invalid_lbool_int_value of int

type t = [ `t | `f | `u ]

val to_string : t -> string

val of_int : int -> t


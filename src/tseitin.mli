module type S = sig
  type t
  val (~:) : t -> t
end

module Make(B : S) : sig
  open B
  val bfalse : t -> t list list
  val btrue : t -> t list list
  val bnot : t -> t -> t list list
  val bwire : t -> t -> t list list
  val bnor : t -> t list -> t list list
  val bor : t -> t list -> t list list
  val bnand : t -> t list -> t list list
  val band : t -> t list -> t list list
  val bxor : t -> t -> t -> t list list
end


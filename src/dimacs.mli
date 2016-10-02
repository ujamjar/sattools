module type Cnf = sig
  type t
  val iter : (int list -> unit) -> t -> unit
  val nvars : t -> int
  val nterms : t -> int
end

module IntList : Cnf

module Make(Cnf : Cnf) : sig

  (** write SAT to file *)
  val write : out_channel -> Cnf.t -> unit

  (** read SAT result file *)
  val read_sat_result : string -> int list Result.t

  (** run SAT solver, parse and return results *)
  val run : ?solver:string -> Cnf.t -> int list Result.t

end

include module type of Make(IntList)


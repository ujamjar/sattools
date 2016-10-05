module F : sig
  module Vec : sig
    type vec_s = Minisat_bindings.Bindings(Minisat_stubs).Vec.vec_s
    val vec_s : vec_s Ctypes.structure Ctypes.typ
    type t = vec_s Ctypes.structure Ctypes.ptr
    val t : vec_s Ctypes.structure Ctypes_static.ptr Ctypes.typ

    val create : (unit -> vec_s Ctypes.structure Ctypes_static.ptr Minisat_stubs.return)
      Minisat_stubs.result

    val destroy : (vec_s Ctypes.structure Ctypes_static.ptr -> unit Minisat_stubs.return)
      Minisat_stubs.result

    val clear : (vec_s Ctypes.structure Ctypes_static.ptr -> unit Minisat_stubs.return)
      Minisat_stubs.result

    val push : (vec_s Ctypes.structure Ctypes_static.ptr -> int -> bool -> unit Minisat_stubs.return)
      Minisat_stubs.result
  end
  
  type sat_solver_s = Minisat_bindings.Bindings(Minisat_stubs).sat_solver_s
  val sat_solver_s : sat_solver_s Ctypes.structure Ctypes.typ
  type t = sat_solver_s Ctypes.structure Ctypes.ptr
  val t : sat_solver_s Ctypes.structure Ctypes_static.ptr Ctypes.typ
  
  val create : (unit -> sat_solver_s Ctypes.structure Ctypes_static.ptr Minisat_stubs.return)
    Minisat_stubs.result

  val destroy : (sat_solver_s Ctypes.structure Ctypes_static.ptr -> unit Minisat_stubs.return)
    Minisat_stubs.result
  
  val new_var : (sat_solver_s Ctypes.structure Ctypes_static.ptr -> unit Minisat_stubs.return)
    Minisat_stubs.result
  
  val add_clause :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     Vec.vec_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  
  val simplify :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  
  val solve :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  
  val solve_with_assumptions :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     Vec.vec_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  
  val value_of :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int -> int Minisat_stubs.return)
    Minisat_stubs.result
  
  val n_vars :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  
  val n_clauses :
    (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  
  val mem_used : (unit -> float Minisat_stubs.return) Minisat_stubs.result
  val cpu_time : (unit -> float Minisat_stubs.return) Minisat_stubs.result

end

exception Minisat_bad_result_value

exception Minisat_bad_clause

module L : sig
  module Vec = F.Vec
  val create :
    (unit ->
     F.sat_solver_s Ctypes.structure Ctypes_static.ptr Minisat_stubs.return)
    Minisat_stubs.result
  val destroy :
    (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     unit Minisat_stubs.return)
    Minisat_stubs.result
  val new_var :
    (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     unit Minisat_stubs.return)
    Minisat_stubs.result
  val add_clause :
    F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
    F.Vec.vec_s Ctypes.structure Ctypes_static.ptr -> unit
  val solve :
    F.sat_solver_s Ctypes.structure Ctypes_static.ptr -> Sattools.Lbool.t
  val solve_with_assumptions :
    F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
    F.Vec.vec_s Ctypes.structure Ctypes_static.ptr -> Sattools.Lbool.t
  val simplify : F.sat_solver_s Ctypes.structure Ctypes_static.ptr -> bool
  val value_of :
    F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
    int -> Sattools.Lbool.t
  val n_vars :
    (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  val n_clauses :
    (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
     int Minisat_stubs.return)
    Minisat_stubs.result
  val mem_use : (unit -> float Minisat_stubs.return) Minisat_stubs.result
  val cpu_time : (unit -> float Minisat_stubs.return) Minisat_stubs.result
end

type t = { solver : F.t; mutable num_vars : int; vec : L.Vec.t; }

exception Minisat_zero_literal

val create : unit -> t
val destroy : t -> unit Minisat_stubs.return
val vec_of_lits : L.Vec.vec_s Ctypes.structure Ctypes_static.ptr -> int list -> unit
val add_vars : t -> int list -> unit
val add_clause : t -> int list -> unit
val solve : ?assumptions:int list -> t -> Sattools.Lbool.t
val get_model : t -> int -> Sattools.Lbool.t
val get_all_models : t -> Sattools.Lbool.t array

module X : sig
  type solver = t
  val create : unit -> t
  val destroy : t -> unit Minisat_stubs.return
  val add_clause : t -> int list -> unit
  val get_result : t -> int -> int
  val solve_with_model : t -> [> `sat of int list | `unsat ]
  val solve : t -> [> `sat of unit | `unsat ]
  val model : t -> int -> Sattools.Lbool.t
end


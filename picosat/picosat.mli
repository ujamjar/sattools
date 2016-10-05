module F :
  sig
    type sat_solver_s = Picosat_bindings.Bindings(Picosat_stubs).sat_solver_s
    val sat_solver_s : sat_solver_s Ctypes.structure Ctypes.typ
    type t = sat_solver_s Ctypes.structure Ctypes.ptr
    val t : sat_solver_s Ctypes.structure Ctypes_static.ptr Ctypes.typ
    val create :
      (unit ->
       sat_solver_s Ctypes.structure Ctypes_static.ptr Picosat_stubs.return)
      Picosat_stubs.result
    val destroy :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Picosat_stubs.return)
      Picosat_stubs.result
    val add :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> int Picosat_stubs.return)
      Picosat_stubs.result
    val assume :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> unit Picosat_stubs.return)
      Picosat_stubs.result
    val n_vars :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Picosat_stubs.return)
      Picosat_stubs.result
    val n_clauses :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Picosat_stubs.return)
      Picosat_stubs.result
    val solve :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> int Picosat_stubs.return)
      Picosat_stubs.result
    val deref :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> int Picosat_stubs.return)
      Picosat_stubs.result
    val push :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Picosat_stubs.return)
      Picosat_stubs.result
    val pop :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Picosat_stubs.return)
      Picosat_stubs.result
  end
exception Picosat_bad_result_value
exception Picosat_solver_error
module L :
  sig
    val create :
      (unit ->
       F.sat_solver_s Ctypes.structure Ctypes_static.ptr Picosat_stubs.return)
      Picosat_stubs.result
    val destroy :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Picosat_stubs.return)
      Picosat_stubs.result
    val add :
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr -> int -> unit
    val assume :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> unit Picosat_stubs.return)
      Picosat_stubs.result
    val solve :
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr -> [> `f | `t | `u ]
    val deref :
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
      int -> [> `f | `t ]
    val n_vars :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Picosat_stubs.return)
      Picosat_stubs.result
    val n_clauses :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Picosat_stubs.return)
      Picosat_stubs.result
  end
type t = { solver : F.t; mutable num_vars : int; }
exception Picosat_zero_literal
val create : unit -> t
val destroy : t -> unit Picosat_stubs.return
val count_vars : t -> int list -> unit
val add_clause : t -> int list -> unit
val solve : ?assumptions:int list -> t -> [> `f | `t | `u ]
val get_model : t -> int -> [> `f | `t ]
val get_all_models : t -> [> `f | `t | `u ] array
module X :
  sig
    type solver = t
    val create : unit -> t
    val destroy : t -> unit Picosat_stubs.return
    val add_clause : t -> int list -> unit
    val get_result : t -> int -> int
    val solve_with_model : t -> [> `sat of int list | `unsat ]
    val solve : t -> [> `sat of unit | `unsat ]
    val model : t -> int -> [> `f | `t ]
  end

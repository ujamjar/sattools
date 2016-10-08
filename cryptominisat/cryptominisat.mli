module F :
  sig
    module Vec :
      sig
        type vec_s =
            Cryptominisat_bindings.Bindings(Cryptominisat_stubs).Vec.vec_s
        val vec_s : vec_s Ctypes.structure Ctypes.typ
        type t = vec_s Ctypes.structure Ctypes.ptr
        val t : vec_s Ctypes.structure Ctypes_static.ptr Ctypes.typ
        val create :
          (unit ->
           vec_s Ctypes.structure Ctypes_static.ptr
           Cryptominisat_stubs.return)
          Cryptominisat_stubs.result
        val destroy :
          (vec_s Ctypes.structure Ctypes_static.ptr ->
           unit Cryptominisat_stubs.return)
          Cryptominisat_stubs.result
        val clear :
          (vec_s Ctypes.structure Ctypes_static.ptr ->
           unit Cryptominisat_stubs.return)
          Cryptominisat_stubs.result
        val push_back :
          (vec_s Ctypes.structure Ctypes_static.ptr ->
           int -> bool -> unit Cryptominisat_stubs.return)
          Cryptominisat_stubs.result
      end
    type sat_solver_s =
        Cryptominisat_bindings.Bindings(Cryptominisat_stubs).sat_solver_s
    val sat_solver_s : sat_solver_s Ctypes.structure Ctypes.typ
    type t = sat_solver_s Ctypes.structure Ctypes.ptr
    val t : sat_solver_s Ctypes.structure Ctypes_static.ptr Ctypes.typ
    val create :
      (int ->
       Signed.long ->
       int ->
       sat_solver_s Ctypes.structure Ctypes_static.ptr
       Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val destroy :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val new_vars :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val new_var :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val add_clause :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       Vec.vec_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val solve :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val solve_with_assumptions :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       Vec.vec_s Ctypes.structure Ctypes_static.ptr ->
       int Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val get_model :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> int Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val print_stats :
      (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
  end
exception Cryptominisat_bad_result_value
module L :
  sig
    module Vec : module type of F.Vec
    val max_long : Signed.Long.t
    val create :
      ?verbose:int ->
      ?conflict_limit:Signed.long ->
      ?threads:int ->
      unit ->
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr
      Cryptominisat_stubs.return
    val destroy :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val new_vars :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       int -> unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val new_var :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val add_clause :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       F.Vec.vec_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
    val solve :
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr -> Sattools.Lbool.t
    val solve_with_assumptions :
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
      F.Vec.vec_s Ctypes.structure Ctypes_static.ptr -> Sattools.Lbool.t
    val get_model :
      F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
      int -> Sattools.Lbool.t
    val print_stats :
      (F.sat_solver_s Ctypes.structure Ctypes_static.ptr ->
       unit Cryptominisat_stubs.return)
      Cryptominisat_stubs.result
  end
type t = { solver : F.t; mutable num_vars : int; vec : L.Vec.t; }
exception Cryptominisat_zero_literal
val create :
  ?verbose:int -> ?conflict_limit:Signed.long -> ?threads:int -> unit -> t
val destroy : t -> unit Cryptominisat_stubs.return
val vec_of_lits :
  L.Vec.vec_s Ctypes.structure Ctypes_static.ptr -> int list -> unit
val add_vars : t -> int list -> unit
val add_clause : t -> int list -> unit Cryptominisat_stubs.return
val solve : ?assumptions:int list -> t -> Sattools.Lbool.t
val get_model : t -> int -> Sattools.Lbool.t
val get_all_models : t -> Sattools.Lbool.t array
val print_stats : t -> unit Cryptominisat_stubs.return
module X :
  sig
    type solver = t
    val create : unit -> t
    val destroy : t -> unit Cryptominisat_stubs.return
    val add_clause : t -> int list -> unit Cryptominisat_stubs.return
    val get_result : t -> int -> int
    val solve_with_model : t -> [> `sat of int list | `unsat ]
    val solve : t -> [> `sat of unit | `unsat ]
    val model : t -> int -> Sattools.Lbool.t
  end

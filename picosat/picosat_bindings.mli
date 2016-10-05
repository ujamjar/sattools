module Bindings :
  functor (F : Cstubs.FOREIGN) ->
    sig
      type sat_solver_s
      val sat_solver_s : sat_solver_s Ctypes.structure Ctypes.typ
      type t = sat_solver_s Ctypes.structure Ctypes.ptr
      val t : sat_solver_s Ctypes.structure Ctypes_static.ptr Ctypes.typ
      val create :
        (unit -> sat_solver_s Ctypes.structure Ctypes_static.ptr F.return)
        F.result
      val destroy :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> unit F.return)
        F.result
      val add :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         int -> int F.return)
        F.result
      val assume :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         int -> unit F.return)
        F.result
      val n_vars :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val n_clauses :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val solve :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         int -> int F.return)
        F.result
      val deref :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         int -> int F.return)
        F.result
      val push :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val pop :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
    end

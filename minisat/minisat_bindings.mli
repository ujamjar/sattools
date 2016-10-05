module Bindings :
  functor (F : Cstubs.FOREIGN) ->
    sig
      module Vec :
        sig
          type vec_s
          val vec_s : vec_s Ctypes.structure Ctypes.typ
          type t = vec_s Ctypes.structure Ctypes.ptr
          val t : vec_s Ctypes.structure Ctypes_static.ptr Ctypes.typ
          val create :
            (unit -> vec_s Ctypes.structure Ctypes_static.ptr F.return)
            F.result
          val destroy :
            (vec_s Ctypes.structure Ctypes_static.ptr -> unit F.return)
            F.result
          val clear :
            (vec_s Ctypes.structure Ctypes_static.ptr -> unit F.return)
            F.result
          val push :
            (vec_s Ctypes.structure Ctypes_static.ptr ->
             int -> bool -> unit F.return)
            F.result
        end
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
      val new_var :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> unit F.return)
        F.result
      val add_clause :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         Vec.vec_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val simplify :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val solve :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val solve_with_assumptions :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         Vec.vec_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val value_of :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr ->
         int -> int F.return)
        F.result
      val n_vars :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val n_clauses :
        (sat_solver_s Ctypes.structure Ctypes_static.ptr -> int F.return)
        F.result
      val mem_used : (unit -> float F.return) F.result
      val cpu_time : (unit -> float F.return) F.result
    end

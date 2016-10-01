#include "minisat_intf.h"

vect minisat_stubs_vec_create(void) { return new vec<Lit>(); }
void minisat_stubs_vec_destroy(vect v) { delete v; }
void minisat_stubs_vec_clear(vect v) { v->clear(); }
void minisat_stubs_vec_push(vect v, int l, int s) { v->push(mkLit(l,(bool) s)); }

solver minisat_stubs_new() {
  return new Solver();
}

void minisat_stubs_delete(solver solver){
  delete solver;
}

int minisat_stubs_new_var(solver solver) {
  return solver->newVar();
}

int minisat_stubs_add_clause(solver solver, vect clause) {
  return (int) solver->addClause(*clause);
}

int minisat_stubs_simplify(solver solver) {
  return (int) solver->simplify();
}

int minisat_stubs_solve(solver solver) {
  if(solver->solve()) {
    return 0;
  } else {
    return 1;
  }
}

int minisat_stubs_solve_with_assumptions(solver solver, vect assumptions) {
  if(solver->solve(*assumptions)) {
    return 0;
  } else {
    return 1;
  }
}

int minisat_stubs_value_of(solver solver, int var) {
  if (var >= solver->model.size()){
    return 3;
  }
  lbool val = solver->model[var];

  if(val == l_False) {
    return 0;
  } else if(val == l_True) {
    return 1;
  } else if (val == l_Undef) {
    return 2;
  } else {
    return 3;
  }
}

int minisat_stubs_n_vars(solver solver) {
  return solver->nVars();
}

int minisat_stubs_n_clauses(solver solver) {
  return solver->nClauses();
}

double minisat_stubs_mem_used() {
  return memUsedPeak();
}

double minisat_stubs_cpu_time() {
  return cpuTime();
}

#include "cryptominisat_intf.h"

vec cryptominisat_stubs_vec_create(void) { return new vector<Lit>(); }
void cryptominisat_stubs_vec_destroy(vec v) { delete v; }
void cryptominisat_stubs_vec_clear(vec v) { v->clear(); }
void cryptominisat_stubs_vec_push_back(vec v, int l, int s) { v->push_back(Lit(l,(bool) s)); }

SATSolver *cryptominisat_stubs_create(
    int verbose,
    long confl_limit,
    int num_threads) {

    SATSolver *cmsat = new SATSolver;
    if (NULL != cmsat) {
      cmsat->set_max_confl(confl_limit);
      cmsat->set_verbosity(verbose);
      cmsat->set_num_threads(num_threads);
    }

    return cmsat;
}

void cryptominisat_stubs_destroy(SATSolver *s) { delete s; }

void cryptominisat_stubs_add_clause(SATSolver *s, vec c) { s->add_clause(*c); }

void cryptominisat_stubs_new_vars(SATSolver *s, int n) { s->new_vars(n); }

void cryptominisat_stubs_new_var(SATSolver *s) { s->new_var(); }

static int int_of_lbool(lbool b) {
  return 
    b == l_True  ? 0 :
    b == l_False ? 1 :
    b == l_Undef ? 2 :
                   3; // error - not expected to happen
}

int cryptominisat_stubs_solve(SATSolver *s) { 
  return int_of_lbool(s->solve());
}

int cryptominisat_stubs_solve_with_assumptions(SATSolver *s, vec assump) {
  return int_of_lbool(s->solve(assump));
}

int cryptominisat_stubs_get_model(SATSolver *s, int i) {
  return int_of_lbool(s->get_model()[i]);
}

void cryptominisat_stubs_print_stats(SATSolver *s) {
  s->print_stats();
}


#ifdef __cplusplus
#define __STDC_LIMIT_MACROS
#define __STDC_FORMAT_MACROS 
#include <minisat/core/Solver.h>
#include <minisat/utils/System.h>
using namespace Minisat;
typedef Solver *solver;
typedef vec<Lit> *vect;
#else
typedef void *solver;
typedef void *vect;
#endif

#ifdef __cplusplus
extern "C" {
#endif

vect minisat_stubs_vec_create(void);
void minisat_stubs_vec_destroy(vect v);
void minisat_stubs_vec_clear(vect v);
void minisat_stubs_vec_push(vect v, int l, int s);

solver minisat_stubs_new();
void minisat_stubs_delete(solver solver);
int minisat_stubs_new_var(solver solver);
int minisat_stubs_add_clause(solver solver, vect clause);
int minisat_stubs_simplify(solver solver);
int minisat_stubs_solve(solver solver);
int minisat_stubs_solve_with_assumptions(solver solver, vect assumptions);
int minisat_stubs_value_of(solver solver, int var);
int minisat_stubs_n_vars(solver solver);
int minisat_stubs_n_clauses(solver solver);
double minisat_stubs_mem_used();
double minisat_stubs_cpu_time();
#ifdef __cplusplus
}
#endif

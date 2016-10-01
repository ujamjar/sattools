#ifdef __cplusplus
#include <vector>
#include <cryptominisat4/cryptominisat.h>
using std::vector;
using namespace CMSat;
typedef vector<Lit> *vec;
typedef SATSolver *solver;
#else
typedef void *vec;
typedef void *solver;
#endif

#ifdef __cplusplus
extern "C" {
#endif

  vec cryptominisat_stubs_vec_create(void);
  void cryptominisat_stubs_vec_destroy(vec v);
  void cryptominisat_stubs_vec_clear(vec v);
  void cryptominisat_stubs_vec_push_back(vec v, int l, int s);

  solver cryptominisat_stubs_create(int verbose, long confl_limit, int num_threads);
  void cryptominisat_stubs_destroy(solver s);
  void cryptominisat_stubs_add_clause(solver s, vec c);
  void cryptominisat_stubs_new_vars(solver s, int n);
  void cryptominisat_stubs_new_var(solver s);
  int cryptominisat_stubs_solve(solver s);
  int cryptominisat_stubs_solve_with_assumptions(solver s, vec assump);
  int cryptominisat_stubs_get_model(solver s, int i);
  void cryptominisat_stubs_print_stats(solver s);

#ifdef __cplusplus
}
#endif

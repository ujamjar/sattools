.PHONY: all

all: test.byte test.native

INC=`opam config var lib`/ctypes

minisat_bindings.cmo minisat_bindings.cmi: minisat_bindings.ml
	ocamlfind c -c -package ctypes.stubs minisat_bindings.ml

minisat_bindings.cmx: minisat_bindings.ml
	ocamlfind opt -c -package ctypes.stubs minisat_bindings.ml

minisat_cstubs.c minisat_stubs.ml: minisat_bindings.cmo minisat_stubgen.ml
	ocamlfind c -o minisat_stubgen.byte \
		-package ctypes.stubs -linkpkg \
		-I bindings \
		minisat_bindings.cmo minisat_stubgen.ml
	./minisat_stubgen.byte -c > minisat_cstubs.c
	./minisat_stubgen.byte -ml > minisat_stubs.ml

minisat_intf.o: minisat_intf.cc
	g++ -c -shared -fPIC minisat_intf.cc

minisat_cstubs.o: minisat_cstubs.c
	gcc -c -shared -fPIC -I${INC} minisat_cstubs.c

minisat_stubs.cmo minisat_stubs.cmi: minisat_stubs.ml
	ocamlfind c -c -package ctypes.stubs minisat_stubs.ml

minisat_stubs.cmx: minisat_stubs.ml
	ocamlfind opt -c -package ctypes.stubs minisat_stubs.ml

minisat.cmo minisat.cmi: minisat.ml minisat_stubs.cmi
	ocamlfind c -c -package ctypes.stubs -I ../src minisat.ml

minisat.cmx: minisat.ml minisat_stubs.cmi
	ocamlfind opt -c -package ctypes.stubs -I ../src minisat.ml

ominisat.cma ominisat.cmxa: \
	minisat.cmo minisat_bindings.cmo minisat_stubs.cmo \
	minisat.cmx minisat_bindings.cmx minisat_stubs.cmx \
	minisat_cstubs.o minisat_intf.o 
	ocamlmklib -v -linkall -o ominisat \
		minisat_cstubs.o minisat_intf.o \
		minisat_bindings.cmo minisat_stubs.cmo minisat.cmo \
		minisat_bindings.cmx minisat_stubs.cmx minisat.cmx \
		-L. -lminisat -lstdc++ 

test.byte: test.ml ominisat.cma
	ocamlfind c -o test.byte -package ctypes.stubs -linkpkg -custom \
		-I ../src ../src/sattools.cma ominisat.cma test.ml

test.native: test.ml ominisat.cmxa
	ocamlfind opt -o test.native -package ctypes.stubs -linkpkg \
		-I ../src ../src/sattools.cmxa ominisat.cmxa test.ml

clean:
	rm -f *.cmo *.cmi *.cmx *.cma *.cmxa *.a *.o *.so \
		*.byte *.native \
		minisat_cstubs.c minisat_stubs.ml


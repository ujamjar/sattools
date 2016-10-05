.PHONY: all

all: test.byte test.native

INC=`opam config var lib`/ctypes

cryptominisat_bindings.cmo cryptominisat_bindings.cmi: cryptominisat_bindings.mli cryptominisat_bindings.ml
	ocamlfind c -c -bin-annot -package ctypes.stubs cryptominisat_bindings.mli cryptominisat_bindings.ml

cryptominisat_bindings.cmx: cryptominisat_bindings.ml
	ocamlfind opt -c -package ctypes.stubs cryptominisat_bindings.ml

cryptominisat_cstubs.c cryptominisat_stubs.ml: cryptominisat_bindings.cmo cryptominisat_stubgen.ml
	ocamlfind c -o cryptominisat_stubgen.byte \
		-package ctypes.stubs -linkpkg \
		-I bindings \
		cryptominisat_bindings.cmo cryptominisat_stubgen.ml
	./cryptominisat_stubgen.byte -c > cryptominisat_cstubs.c
	./cryptominisat_stubgen.byte -ml > cryptominisat_stubs.ml

cryptominisat_intf.o: cryptominisat_intf.cc
	g++ -c -shared -fPIC cryptominisat_intf.cc

cryptominisat_cstubs.o: cryptominisat_cstubs.c
	gcc -c -shared -fPIC -I${INC} cryptominisat_cstubs.c

cryptominisat_stubs.cmo cryptominisat_stubs.cmi: cryptominisat_stubs.ml
	ocamlfind c -c -bin-annot -package ctypes.stubs cryptominisat_stubs.ml

cryptominisat_stubs.cmx: cryptominisat_stubs.ml
	ocamlfind opt -c -package ctypes.stubs cryptominisat_stubs.ml

cryptominisat.cmo cryptominisat.cmi: cryptominisat.mli cryptominisat.ml cryptominisat_stubs.cmo cryptominisat_bindings.cmo
	ocamlfind c -c -bin-annot -package ctypes.stubs -I ../src cryptominisat.mli cryptominisat.ml

cryptominisat.cmx: cryptominisat.ml cryptominisat_stubs.cmx cryptominisat_bindings.cmx
	ocamlfind opt -c -package ctypes.stubs -I ../src cryptominisat.ml

ocryptominisat.cma ocryptominisat.cmxa: \
	cryptominisat.cmo cryptominisat_bindings.cmo cryptominisat_stubs.cmo \
	cryptominisat.cmx cryptominisat_bindings.cmx cryptominisat_stubs.cmx \
	cryptominisat_cstubs.o cryptominisat_intf.o 
	ocamlmklib -v -linkall -o ocryptominisat \
		cryptominisat_cstubs.o cryptominisat_intf.o \
		cryptominisat_bindings.cmo cryptominisat_stubs.cmo cryptominisat.cmo \
		cryptominisat_bindings.cmx cryptominisat_stubs.cmx cryptominisat.cmx \
		-L. -lcryptominisat4 -lstdc++ 

test.byte: test.ml ocryptominisat.cma
	ocamlfind c -o test.byte -package ctypes.stubs -linkpkg -custom \
		-I ../src ../src/sattools.cma ocryptominisat.cma test.ml

test.native: test.ml ocryptominisat.cmxa
	ocamlfind opt -o test.native -package ctypes.stubs -linkpkg \
		-I ../src ../src/sattools.cmxa ocryptominisat.cmxa test.ml

clean:
	rm -f *.cmo *.cmi *.cmx *.cma *.cmxa *.cmt *.cmti *.a *.o *.so \
		*.byte *.native \
		cryptominisat_cstubs.c cryptominisat_stubs.ml


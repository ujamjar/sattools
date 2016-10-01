.PHONY: all

all: test.byte test.native

INC=`opam config var lib`/ctypes

picosat_bindings.cmo picosat_bindings.cmi: picosat_bindings.ml
	ocamlfind c -c -package ctypes.stubs picosat_bindings.ml

picosat_bindings.cmx: picosat_bindings.ml
	ocamlfind opt -c -package ctypes.stubs picosat_bindings.ml

picosat_cstubs.c picosat_stubs.ml: picosat_bindings.cmo picosat_stubgen.ml
	ocamlfind c -o picosat_stubgen.byte \
		-package ctypes.stubs -linkpkg \
		-I bindings \
		picosat_bindings.cmo picosat_stubgen.ml
	./picosat_stubgen.byte -c > picosat_cstubs.c
	./picosat_stubgen.byte -ml > picosat_stubs.ml

picosat_cstubs.o: picosat_cstubs.c
	gcc -c -shared -fPIC -I${INC} picosat_cstubs.c

picosat_stubs.cmo picosat_stubs.cmi: picosat_stubs.ml
	ocamlfind c -c -package ctypes.stubs picosat_stubs.ml

picosat_stubs.cmx: picosat_stubs.ml
	ocamlfind opt -c -package ctypes.stubs picosat_stubs.ml

picosat.cmo picosat.cmi: picosat.ml picosat_stubs.cmi
	ocamlfind c -c -package ctypes.stubs -I ../src picosat.ml

picosat.cmx: picosat.ml picosat_stubs.cmi
	ocamlfind opt -c -package ctypes.stubs -I ../src picosat.ml

opicosat.cma opicosat.cmxa: \
	picosat.cmo picosat_bindings.cmo picosat_stubs.cmo \
	picosat.cmx picosat_bindings.cmx picosat_stubs.cmx \
	picosat_cstubs.o 
	ocamlmklib -v -linkall -o opicosat \
		picosat_cstubs.o \
		picosat_bindings.cmo picosat_stubs.cmo picosat.cmo \
		picosat_bindings.cmx picosat_stubs.cmx picosat.cmx \
		-L. -lpicosat 

test.byte: test.ml opicosat.cma
	ocamlfind c -g -o test.byte -package ctypes.stubs -linkpkg -custom \
		-I ../src ../src/sattools.cma opicosat.cma test.ml

test.native: test.ml opicosat.cmxa
	ocamlfind opt -o test.native -package ctypes.stubs -linkpkg \
		-I ../src ../src/sattools.cmxa opicosat.cmxa test.ml

clean:
	rm -f *.cmo *.cmi *.cmx *.cma *.cmxa *.a *.o *.so \
		*.byte *.native \
		picosat_cstubs.c picosat_stubs.ml


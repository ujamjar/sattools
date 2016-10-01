all: test.byte test.native

test.byte: test.ml
	ocamlfind c \
		-package sattools.picosat,sattools.minisat,sattools.cryptominisat -linkpkg \
		-o test.byte \
		test.ml

test.native: test.ml
	ocamlfind opt \
		-package sattools.picosat,sattools.minisat,sattools.cryptominisat -linkpkg \
		-o test.native \
		test.ml

clean:
	rm -f *.cmo *.cmi *.cmx *.o *.byte *.native 	


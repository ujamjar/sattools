all: sattools.cma sattools.cmxa

sattools.cmo sattools.cmi: sattools.mli sattools.ml
	ocamlfind c -c sattools.mli sattools.ml

sattools.cmx: sattools.cmi sattools.ml
	ocamlfind opt -c sattools.ml

dimacs.cmo dimacs.cmi: dimacs.mli dimacs.ml
	ocamlfind c -c dimacs.mli dimacs.ml

dimacs.cmx: dimacs.cmi dimacs.ml
	ocamlfind opt -c dimacs.ml

tseitin.cmo tseitin.cmi: tseitin.mli tseitin.ml
	ocamlfind c -c tseitin.mli tseitin.ml

tseitin.cmx: tseitin.cmi tseitin.ml
	ocamlfind opt -c tseitin.ml

sattools.cma: sattools.cmo dimacs.cmo tseitin.cmo
	ocamlfind c -a -linkall -o sattools.cma sattools.cmo dimacs.cmo tseitin.cmo

sattools.cmxa: sattools.cmx dimacs.cmx tseitin.cmx
	ocamlfind opt -a -linkall -o sattools.cmxa sattools.cmx dimacs.cmx tseitin.cmx

clean:
	rm -f *.cmi *.cmo *.cmx *.cma *.cmxa *.o *.a


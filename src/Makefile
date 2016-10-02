all: sattools.cma sattools.cmxa

PACK=-for-pack Sattools

dimacs.cmo dimacs.cmi: dimacs.mli dimacs.ml
	ocamlfind c -c $(PACK) dimacs.mli dimacs.ml

dimacs.cmx: dimacs.cmi dimacs.ml
	ocamlfind opt -c $(PACK) dimacs.ml

result.cmo result.cmi: result.mli result.ml
	ocamlfind c -c $(PACK) result.mli result.ml

result.cmx: result.cmi result.ml
	ocamlfind opt -c $(PACK) result.ml

lbool.cmo lbool.cmi: lbool.mli lbool.ml
	ocamlfind c -c $(PACK) lbool.mli lbool.ml

lbool.cmx: lbool.cmi lbool.ml
	ocamlfind opt -c $(PACK) lbool.ml

libs.cmo libs.cmi: libs.mli libs.ml
	ocamlfind c -c $(PACK) libs.mli libs.ml

libs.cmx: libs.cmi libs.ml
	ocamlfind opt -c $(PACK) libs.ml

tseitin.cmo tseitin.cmi: tseitin.mli tseitin.ml
	ocamlfind c -c $(PACK) tseitin.mli tseitin.ml

tseitin.cmx: tseitin.cmi tseitin.ml
	ocamlfind opt -c $(PACK) tseitin.ml

sattools.cmo sattools.cmi: result.cmo lbool.cmo libs.cmo tseitin.cmo dimacs.cmo
	ocamlfind c -pack -o sattools.cmo $<

sattools.cmx: result.cmx lbool.cmx libs.cmx tseitin.cmx dimacs.cmx
	ocamlfind opt -pack -o sattools.cmx $<

sattools.cma: sattools.cmo 
	ocamlfind c -a -linkall -o sattools.cma sattools.cmo 

sattools.cmxa: sattools.cmx dimacs.cmx tseitin.cmx
	ocamlfind opt -a -linkall -o sattools.cmxa sattools.cmx 

clean:
	rm -f *.cmi *.cmo *.cmx *.cma *.cmxa *.o *.a


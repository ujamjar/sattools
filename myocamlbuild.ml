open Ocamlbuild_plugin

let link libs = S (List.flatten @@ List.map (fun l -> [A "-cclib"; A ("-l" ^ l)]) libs)

let ctypes_inc =
  [A "-ccopt"; A("-I" ^ getenv ~default:"." "CTYPES_INC_DIR")]

let () = dispatch @@ function
  | Before_options ->
    Options.use_ocamlfind := true
  | After_rules -> begin
    (* C[++]-headers *)
    dep ["compile"; "c"] [
      "minisat/minisat_intf.h";
      "cryptominisat/cryptominisat_intf.h";
    ]; 

    (* debugging *)
    flag ["ocaml_verbose"; "ocaml"; "compile"] @@ S[A"-verbose"];
    flag ["ocaml_versboe"; "ocaml"; "link"] @@ S[A"-verbose"];

    (* generate the stubs files *)
    rule "cstubs: x_stubgen.byte -> x_cstubs.c x_stubs.ml" 
      ~prods:["%_cstubs.c"; "%_stubs.ml"]
      ~deps:["%_stubgen.byte"] 
      (fun env _ ->
        Seq [
          Cmd (S [ A (env "%_stubgen.byte"); A "-ml"; Sh ">"; A (env "%_stubs.ml") ]);
          Cmd (S [ A (env "%_stubgen.byte"); A "-c"; Sh ">"; A (env "%_cstubs.c") ]);
        ]);

    (* compile C++ file *)
    rule "x.cc -> c.o"
      ~prods:["%.o"]
      ~deps:["%.cc"]
      (fun env _ ->
        Cmd (S [ A"g++"; A"-c"; A"-shared"; A"-fPIC"; 
                 A(env "%.cc"); A"-o"; A(env "%.o") ]));

    (* compile C file *)
    flag ["c"; "compile"; "use_minisat"] @@ S([ A"-ccopt"; A"-shared"; ] @ ctypes_inc); 
    flag ["c"; "compile"; "use_picosat"] @@ S([ A"-ccopt"; A"-shared"; ] @ ctypes_inc); 
    flag ["c"; "compile"; "use_cryptominisat"] @@ S([ A"-ccopt"; A"-shared"; ] @ ctypes_inc); 

    (* linking c libs *)
    flag ["c"; "ocamlmklib"; "use_minisat" ] @@ S[ A"-lminisat"; A"-linkall" ];
    flag ["c"; "ocamlmklib"; "use_picosat" ] @@ S[ A"-lpicosat"; A"-linkall" ];
    flag ["c"; "ocamlmklib"; "use_cryptominisat" ] @@ S[ A"-lcryptominisat4"; A"-linkall" ];

    (* dynamic linking *)
    flag ["ocaml"; "link"; "native"; "library"; "shared"; "use_minisat"] @@ S[A"-cclib"; A"-Lminisat"];
    flag ["ocaml"; "link"; "native"; "library"; "shared"; "use_picosat"] @@ S[A"-cclib"; A"-Lpicosat"];
    flag ["ocaml"; "link"; "native"; "library"; "shared"; "use_cryptominisat"] @@ S[A"-cclib"; A"-Lcryptominisat"];

    (* byte code linking *)
    flag ["ocaml"; "link"; "byte"; "library"; "use_minisat"] @@ S[A"-dllib"; A"-lominisat"];
    flag ["ocaml"; "link"; "byte"; "library"; "use_picosat"] @@ S[A"-dllib"; A"-lopicosat"];
    flag ["ocaml"; "link"; "byte"; "library"; "use_cryptominisat"] @@ S[A"-dllib"; A"-locryptominisat"];

    (* native code linkning *)
    flag ["ocaml"; "link"; "native"; "library"; "use_minisat"] @@ 
      link ["ominisat";"minisat";"stdc++"];
    flag ["ocaml"; "link"; "native"; "library"; "use_picosat"] @@ 
      link ["opicosat";"picosat";];
    flag ["ocaml"; "link"; "native"; "library"; "use_cryptominisat"] @@ 
      link ["ocryptominisat";"cryptominisat4";"stdc++"];
  end
  | _ -> ()


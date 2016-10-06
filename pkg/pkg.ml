#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "sattools" @@ fun c ->
  Ok [ 
    Pkg.mllib "src/sattools.mlpack";
    Pkg.lib "src/sattools.cmi";
    Pkg.lib "src/sattools.cmti";
    Pkg.lib "src/sattools.cmx";

    Pkg.clib "minisat/libominisat.clib";
    Pkg.mllib ~api:["Minisat_bindings"; "Minisat"] "minisat/ominisat.mllib";
    
    Pkg.clib "picosat/libopicosat.clib";
    Pkg.mllib ~api:["Picosat_bindings"; "Picosat"] "picosat/opicosat.mllib";
    
    Pkg.clib "cryptominisat/libocryptominisat.clib";
    Pkg.mllib ~api:["Cryptominisat_bindings"; "Cryptominisat"] "cryptominisat/ocryptominisat.mllib";
  ]

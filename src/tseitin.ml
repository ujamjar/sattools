module type S = sig
  type t
  val (~:) : t -> t
end

module Make(B : S) = struct
  open B

  let bfalse z = [ [ ~: z ] ]

  let btrue z = [ [ z ] ]

  let bnot z x = [ [ x; z ]; [ ~: x; ~: z] ]
  
  let bwire z x = [ [ ~: z; x ]; [ z; ~: x ] ]

  let bnor z x = 
    let sum = List.fold_right (fun x a -> x :: a) x [z] in
    List.fold_right (fun x a -> [ ~: x; ~: z] :: a) x [sum]

  let bor z x = 
    let sum = List.fold_right (fun x a -> x :: a) x [~: z] in
    List.fold_right (fun x a -> [ ~: x; z] :: a) x [sum]

  let bnand z x = 
    let sum = List.fold_right (fun x a -> ~: x :: a) x [~: z] in
    List.fold_right (fun x a -> [x; z] :: a) x [sum]

  let band z x =  
    let sum = List.fold_right (fun x a -> ~: x :: a) x [z] in
    List.fold_right (fun x a -> [x; ~: z] :: a) x [sum]

  let bxor z a b = 
    [ [~: z; ~: a; ~: b]; [~: z; a; b]; [z; ~: a; b]; [z; a; ~: b] ]

end


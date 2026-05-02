
let compress inF outF = 
  let freqlist = Heap.char_freq inF in
  let file = Heap.short_freq_list freqlist in
  let arbre = Heap.arbre file in
  let encodes = Heap.encode arbre in
  let oc = open_out_bin outF in
  let os = Bs.of_out_channel oc in
  let () = Heap.serialise os arbre in
  let ic = open_in inF in
  try
    while true do
      let char = input_char ic in
      let code =
        try
          let leaf = (Char.code char) in
          List.assoc leaf encodes
        with Not_found ->
          failwith ("Caractère non trouvé dans le tableau de codes : " ^ String.make 1 char)
      in
      List.iter (Bs.write_bit os) code;
    done
  with End_of_file ->
    Bs.finalize os;
    close_in ic;
    close_out oc;
    Printf.printf "Compression terminée et écrite dans %s\n" outF
;;

let decompress inF outF =
  let ic = open_in_bin inF in
  let is = Bs.of_in_channel ic in
  let arbre = Heap.deserialise is in
  let oc = open_out outF in  
  let rec decode arbre =
    match arbre with
    | Heap.Leaf c -> c;
    | Heap.Node (gauche, droit) ->
        match Bs.read_bit is with
        | 0 -> decode gauche
        | 1 -> decode droit
        | _ -> failwith "Bit invalide lors de la décompression"
    in
  try
    while true do
      let char_code = decode arbre in
      output_char oc (Char.chr char_code)
    done
   with Bs.End_of_stream ->
    Printf.printf "Fin du flux atteinte. Décompression terminée.\n";

  close_in ic;
  close_out oc;
  Printf.printf "Décompression terminée et écrite dans %s\n" outF
;;

let test_is_singleton_is_empty () =
  let t1 = [(20, Heap.Leaf 3); (2, Heap.Leaf 4); (5, Heap.Leaf 6);] in
  let t2 = [(5, Heap.Leaf 6)] in
  let vide = [] in
  let print_bool b =
    if (b) then Printf.printf ("True \n")
      else Printf.printf ("False\n")
  in  
  print_bool (Heap.is_singleton t1);
  print_bool (Heap.is_singleton t2);
  print_bool (Heap.is_singleton vide);
  print_bool (Heap.is_empty t1);
  print_bool (Heap.is_empty t2);
  print_bool (Heap.is_empty vide);
;;

(* let test_add () =
  let t1 = [(20,Leaf 3); (2, Leaf 4); (5, Leaf 6);] in
  let t2 = [(5, Leaf 6)] in
  let vide = [] in
  let x = (1, Leaf 3) in
    Printf.printf ("\n");   
    List.iter(fun (x, Leaf y) -> Printf.printf "%d, %d\n" x y ) (add x t1);
    Printf.printf ("\n");
    List.iter(fun (x, Leaf y) -> Printf.printf "%d, %d\n" x y ) (add x t2);
    Printf.printf ("\n");
    List.iter(fun (x, Leaf y) -> Printf.printf "%d, %d\n" x y ) (add x vide);
;; *)
    
let test_find_min () =
  let t = [(20,Heap.Leaf 3); (2, Heap.Leaf 4); (2, Heap.Leaf 6);] in
  let min1 = Heap.find_min t in
    Printf.printf "Test find min : %d, %d\n" (fst min1) (match snd min1 with Heap.Leaf y -> y | _ -> -1);
;;
    
let test_remove_min () =
  let t = [(20,Heap.Leaf 3); (2, Heap.Leaf 4); (5, Heap.Leaf 6);] in
  Printf.printf "longeur liste = %d\n" (List.length t);
  (* Printf.printf ("Liste avant suppression\n");
  List.iter(fun (x, Leaf y) -> Printf.printf "%d, %d\n" x y ) (t); *)
  let (min_value, result) = Heap.remove_min t in 
  (* Printf.printf ("Liste après suppression\n");
  List.iter(fun (x, Leaf y) -> Printf.printf "%d, %d\n" x y ) (result); *)
  Printf.printf "long Liste sans min = %d\n" (List.length result);
  Printf.printf "Minimum : %d\n" (fst (min_value));
  (* List.iter(fun (x, Leaf y) -> Printf.printf "%d, \n" x ) (result); *)
;;
    
let test_arbre () =
  Printf.printf ("Test ARBRE 1 \n");
  let frqlist = [(5, Heap.Leaf 1);(20,Heap.Leaf 3); (2, Leaf 4); (3, Leaf 6);] in  (* Liste avec une seule fréquence de feuille *)
  let result = Heap.arbre frqlist in
  Heap.print_tree result;

  Printf.printf ("Test ARBRE 2 + SHORT_FREQ_LIST \n");
  let frqlist2 = [|3; 3; 2; 2; 1; 1|] in
  let file_list2 = Heap.short_freq_list frqlist2 in
  (* Printf.printf "Test short_freq_list:\n";
  List.iter (fun (freq, Leaf i) -> Printf.printf "Fréquence: %d, Feuille: %d\n" freq i) file_list; *)
  let huffman_tree = Heap.arbre file_list2 in
  Printf.printf "Arbre de Huffman généré :\n";
  Heap.print_tree huffman_tree
;;

let test_ARBRE_avec_fichier filename =
  let freqs = Heap.char_freq filename in
  let file_list = Heap.short_freq_list freqs in
  Printf.printf "Liste des feuilles dans la file :\n";
  List.iter (fun (freq, leaf) ->
    match leaf with
    | Heap.Leaf c -> Printf.printf "Caractère: %c, Fréquence: %d\n" (Char.chr c) freq
    | _ -> ()
    ) file_list;
    let huffman_tree = Heap.arbre file_list in
    
    Printf.printf "\nArbre de Huffman généré :\n";
    Heap.print_tree huffman_tree;
  ;;

let test_encode filename =
  let freqs = Heap.char_freq filename in
  let file_list = Heap.short_freq_list freqs in
  Printf.printf "Liste des feuilles dans la file :\n";
  List.iter (fun (freq, leaf) ->
    match leaf with
    | Heap.Leaf c -> Printf.printf "Caractère: %c, Fréquence: %d\n" (Char.chr c) freq
    | _ -> ()
  ) file_list;
  let huffman_tree = Heap.arbre file_list in

  let print_codes codes =
    List.iter
      (fun (value, code) ->
        Printf.printf "%d " value;
        List.iter (fun x -> Printf.printf "%d " x) code;
        Printf.printf "\n"
      )
      codes
  in
  let codes = Heap.encode huffman_tree in
  print_codes codes
;;

let test_serialisation fichier =
  let freqs = Heap.char_freq fichier in
  let file_list = Heap.short_freq_list freqs in
  Printf.printf "Liste des feuilles dans la file :\n";
  List.iter (fun (freq, leaf) ->
    match leaf with
    | Heap.Leaf c -> Printf.printf "Caractère: %c, Fréquence: %d\n" (Char.chr c) freq
    | _ -> ()
  ) file_list;
  let huffman_tree = Heap.arbre file_list in
  let oc = open_out_bin "output.bin" in
  let os = Bs.of_out_channel oc in
  Printf.printf "Sérialisation de l'arbre...\n";
  let () = Heap.serialise os huffman_tree in
  Bs.finalize os;
  close_out oc;
  Heap.print_tree huffman_tree;
  Printf.printf "\n";
  Heap.print_tree (Heap.deserialise (Bs.of_in_channel (open_in_bin "output.bin")))
;;

let test_compress_decompress input_fichier =
   let compressed_fichier = "compressed.bin" in
   Huffman.compress input_fichier compressed_fichier;
   let decompressed_fichier = "decompressed.txt" in
   Huffman.decompress compressed_fichier decompressed_fichier;
   let decompressed_content = Heap.lire_fichier  decompressed_fichier in
   let original_content = Heap.lire_fichier input_fichier in
   let compressed_size = Heap.calculate_fichier_size compressed_fichier in
   let original_size = Heap.calculate_fichier_size input_fichier in
 
   Printf.printf "Lecture du fichier original : %s\n" input_fichier;
   Printf.printf "Contenu original :\n%s\n" original_content;
   Printf.printf "Taille originale : %d octets\n" original_size;
   Printf.printf "Taille compressée : %d octets\n" compressed_size;
   Printf.printf "Contenu décompressé :\n%s\n"  decompressed_content;
   if original_content = decompressed_content then
    Printf.printf "\nSuccès : Le contenu original et décompressé est identique !\n"
  else
    Printf.printf "\nErreur : Le contenu original et décompressé est différent !\n";

  Printf.printf "\n Fin des statistiques.\n"
;;



let fichier = "test1.txt";;

(* EXECUTION DES TESTS *)
Printf.printf "\n TEST DE IS SINGLETON ET EMPTY \n" ;;
let () = test_is_singleton_is_empty ();;
Printf.printf "\n TEST DE ADD \n" ;;
(* let () = test_add ();;  *)
Printf.printf "\n TEST DE FIND MIN \n" ;;
let () = test_find_min ();;
Printf.printf "\n TEST DE REMOVE MIN \n" ;;
let () = test_remove_min ();;
Printf.printf "\n TEST DE ARBRE\n" ;;
let () = test_arbre ();;
Printf.printf "\n TEST DE ARBRE AVEC FICHIER\n" ;;
let () = test_ARBRE_avec_fichier "test1.txt";;
Printf.printf "\n TEST DE ENCODE \n" ;;
let () = test_encode "test1.txt";;
Printf.printf "\nTEST DE SERILISATION \n" ;;
let () = test_serialisation fichier;;
Printf.printf "\n TEST DE COMPRESSE ET DECOMPRESSE \n" ;;
let () = test_compress_decompress fichier;;
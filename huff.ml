(* 
open Heap
open Huffman 
 *)

let print_help () =
  Printf.printf "Usage :\n";
  Printf.printf "  huff --help            Affiche un message d'aide\n";
  Printf.printf "  huff fichier           Compresse le fichier donné en argument pour produire un fichier fichier.hf\n";
  Printf.printf "  huff --stats fichier   Compresse le fichier et affiche des statistiques sur ce dernier\n";
  Printf.printf "\n";
;;

let print_stats fichier =
  Printf.printf "Statistiques pour le fichier : %s\n" fichier;

  let size = Heap.calculate_fichier_size fichier in
  Printf.printf "Taille du fichier original : %d octets\n" size;

  let freqs = Heap.char_freq fichier in
  Printf.printf "Fréquence des caractères :\n";
  Array.iteri (fun i freq ->
    if freq > 0 then
      Printf.printf "Caractère %c : %d\n" (Char.chr i) freq
  ) freqs;

  let compressed_fichier = "compressed.bin" in
  let () = Huffman.compress fichier compressed_fichier in
  let compressed_size = Heap.calculate_fichier_size (compressed_fichier) in

  Printf.printf "Taille du fichier compressé : %d octets\n" compressed_size;

  if size > 0 then
    let compression_r = ((float_of_int compressed_size /. float_of_int size) *. 100.) in
    let compression_ratio = 100.0 -. compression_r in
    Printf.printf "Taux de compression : %f %% \n" compression_ratio;
  else
    Printf.printf "Aucun fichier à compresser.\n";
;;
  



let main () =
  (* Huffman.decompress "fichier";
  Printf.printf ("Entrer le nom du fichier ...");
  let f = read_line () in
  let fichier = open_in f in *)

  let args = Sys.argv in
  match Array.length args with
  | 1 -> 
    print_help ();
  | 2 -> 
    let fichier = args.(1) in
    if fichier = "--help" then
      print_help()
    else if Filename.check_suffix fichier ".hf" then
      let decompressed_fichier = "decompressed.txt" in
      Huffman.decompress fichier decompressed_fichier;
    else
      let compressed_fichier = "compressed.hf" in
      Huffman.compress fichier compressed_fichier;
  | 3 ->
    let option = args.(1) in
    let fichier = args.(2) in
    (match option with 
    | "--stats" ->
      print_stats fichier;
      let compressed_fichier = "compressed.hf" in
      Huffman.compress fichier compressed_fichier;
    | _ -> 
      Printf.printf "Option inconnue : %s\n" option;
      print_help ());
  | _ ->
    Printf.printf "Commande inconnue \n";
;;

let () = main ()
(*heap.ml*)

type tree =
  | Leaf of int
  | Node of tree * tree

type t = (int * tree) list (* remplacer par une définition qui vous convient *)

let empty = []

let is_singleton t = 
  match t with
  | [_] -> true;
  | _ -> false;
;;

let is_empty t =
  match t with 
  | [] -> true;
  | _-> false;
;;

let add pair t =
  (* List.sort (fun (a, _) (b, _) -> compare a b) (pair :: t) *)
  t @ [pair]
;;

let find_min t =
  match t with 
  | [] -> raise Not_found;
  | [x] -> x;
  | _ -> 
    begin
      let sorted_list = List.sort (fun (k1, _) (k2, _) -> compare k1 k2) t in
      List.hd sorted_list
    end
;;

let remove_min t =
  let min = find_min t in
  let rec bis acc t =
    match t with 
    | [] -> (min, List.rev acc);
    | x :: xx -> 
      begin
        if (x == min) then
          (min, (List.rev acc)@xx)
        else
          bis (x :: acc)  xx
      end
    in
    bis [] t
;;

let rec print_tree t =
  match t with
  | Leaf c -> Printf.printf "Leaf %d " c
  | Node (gauche, droit) ->
    Printf.printf "Node ( ";
    print_tree gauche;
    Printf.printf ", ";
    print_tree droit ;
    Printf.printf ") ";
;;
 
let char_freq fichier =
  let tab = Array.make 256 0 in
  let openfichier = open_in fichier in
  let rec bis () =
    try
      let mot = input_byte openfichier in
      tab.(mot) <- tab.(mot) + 1;
      bis () (* Continue jusqu'à la fin du fichier *)
    with End_of_file -> 
      close_in openfichier; (* Ferme le fichier une fois la lecture terminée *)
      tab (* Retourne le tableau des fréquences *)
  in
  bis ()
;;

let short_freq_list frqlist =
  let rec aux i acc = 
    if i < Array.length frqlist then
      let freq = frqlist.(i) in
      if freq > 0 then
        aux (i + 1) ((freq, Leaf i) :: acc)
      else
        aux (i + 1) acc
      else
        acc
      in
      aux 0 []
;; 
          
let rec arbre frqlist =
  match frqlist with
  | [] -> failwith "Arbre vide !"
  | [(x, y)] -> 
    begin
      (* Printf.printf "Hiiii 1\n";
        print_tree y; *)
      y;
    end
  | _ -> 
    begin
      (* Printf.printf "Hiiii 2\n"; *)
      let (min1, frqlist1) = remove_min frqlist in 
      let (min2, frqlist2) = remove_min frqlist1 in  
      let nt = Node(snd min1, snd min2) in 
      (* List.iter(fun (x, y) -> 
        begin
          Printf.printf "%d, \n" x;
          (*print_tree y*)
        end
        ) (frqlist2);  *)
      let nfrqlist = add (fst min1 + fst  min2, nt) frqlist2 in  
      (* List.iter(fun (x, y) -> 
        begin
          Printf.printf "%d, \n" x;
          (*print_tree y*)
        end
        ) (frqlist2);  *)
        arbre nfrqlist 
      end
;;

let rec serialise os tree =
  match tree with 
  | Leaf c -> Bs.write_bit os 0;
              Bs.write_byte os c;
  | Node (gauche,droit) -> 
    Bs.write_bit os  1 ;
    serialise os gauche;
    serialise os  droit 
;;

let rec deserialise is =
  match Bs.read_bit is with
  | 0 -> Leaf (Bs.read_byte is);
  | 1 -> 
      let t1 = deserialise is in
      let t2 = deserialise is in
      Node (t1, t2);
  | _ -> raise (Invalid_argument "ERROR") 
;;

(* let rec encode tree prefix =
  match tree with
  | Leaf value -> [(value, prefix)]
  | Node (left, right) ->
    let left_codes = encode left (prefix ^ "0") in
    let right_codes = encode right (prefix ^ "1") in
    left_codes @ right_codes
;; *)

let encode arbre =
  let rec bis p arbre acc =
    match arbre with
    | Leaf c -> (c, List.rev p) :: acc
    | Node(gauche, droit) ->
      let k = bis (0 :: p) gauche acc in
      bis (1 :: p) droit k
    in
    bis [] arbre []
;;

let calculate_fichier_size fichier =
  try
    let ic = open_in_bin fichier in
    let size = in_channel_length ic in
    close_in ic;
    size
  with
  | Sys_error err ->
      Printf.printf "Erreur lors de l'ouverture du fichier : %s\n" err;
      0
;;

let lire_fichier fichier =
   let ic = open_in fichier in
   let n = in_channel_length ic in
   let content = really_input_string ic n in
   close_in ic;
   content
;;

let ecrire_fichier fichier content =
  let oc = open_out fichier in
  output_string oc content;
  close_out oc
;;

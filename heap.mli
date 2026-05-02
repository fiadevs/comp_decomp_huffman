(*heap.mli*)

type tree =
  | Leaf of int
  | Node of tree * tree

type t = (int * tree) list


(** The type of heaps. Elements are ordered using generic comparison.
*)

val empty : t
(** [empty] is the empty heap. *)

val add : (int * tree) -> t -> t
(** [add e h] add element [e] to [h]. *)

val find_min : t -> (int * tree)
(** [find_min h] returns the smallest elements of [h] w.r.t to 
    the generic comparison [<] *)

val remove_min : t -> (int * tree) * t
(** [remove_min h] returns the pair of the smallest elements of [h] w.r.t to 
    the generic comparison [<] and [h] where that element has been removed. *)

val is_singleton : t -> bool
(** [is_singleton h] returns [true] if [h] contains one element *)

val is_empty : t -> bool
(** [is_empty h] returns [true] if [h] contains zero element *)

val print_tree : tree -> unit
(** [print_tree h] prints the given tree *)

val char_freq : string -> int array
(** [char_freq fichier] calcule la fréquence d'apparition de chaque caractère dans le fichier [fichier].**)

val short_freq_list : int array -> (int*tree) list
(** [short_freq_list h] returns pair of number of caracters and the generated tree *)

val arbre : t -> tree
(** [arbre h] returns the generated tree from a table of pairs (occurence, caracter) *)

val serialise : Bs.ostream -> tree -> unit
(** [serialise os tree] sérialise l'arbre [tree] et l'écrit dans le flux [os].**)

val deserialise : Bs.istream -> tree
(** [deserialise is] désérialise un arbre à partir du flux [is].**)

val encode : tree -> (int * int list) list
(** [encode arbre] encode l'arbre [arbre] en une liste de tuples associant chaque caractère à une liste de bits.**)

(*
val compress : string -> string -> unit
(** [compress inF outF] compresse le fichier [inF] et écrit le résultat dans [outF].**)

val decompress : string -> string -> unit
(** [decompress inF outF] décompresse le fichier [inF] et écrit le résultat dans [outF].**)
*)

val calculate_fichier_size : string -> int
(** [calculate_fichier_size fichier] calcule la taille du fichier [fichier] en octets.**)

val lire_fichier : string -> string
(** [lire_fichier fichier] lit le contenu du fichier [fichier] et le renvoie sous forme de chaîne de caractères.**)

val ecrire_fichier : string -> string -> unit
(** [ecrire_fichier fichier content] écrit la chaîne de caractères [content] dans le fichier [fichier].**)


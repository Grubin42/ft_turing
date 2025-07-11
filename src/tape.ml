(* Représentation de la bande de la machine de Turing *)

(* La bande est représentée par:
   - Un symbole "blanc" (blank) pour les cases non initialisées
   - Une liste des symboles à gauche de la tête (en ordre inverse)
   - Un symbole sous la tête de lecture
   - Une liste des symboles à droite de la tête
*)
type tape = {
  blank: string;              (* Symbole pour les cases vides *)
  left: string list;          (* Symboles à gauche de la tête (ordre inverse) *)
  current: string;            (* Symbole sous la tête de lecture *)
  right: string list;         (* Symboles à droite de la tête *)
}

(* Crée une nouvelle bande à partir d'une chaîne d'entrée et d'un symbole blanc *)
let make_tape input blank =
  match input with
  | "" -> { blank; left = []; current = blank; right = [] }
  | _ ->
      let chars = List.init (String.length input) (String.get input) in
      let chars_str = List.map (String.make 1) chars in
      match chars_str with
      | [] -> { blank; left = []; current = blank; right = [] } (* Ne devrait jamais arriver *)
      | hd :: tl -> { blank; left = []; current = hd; right = tl }

(* Déplace la tête vers la gauche *)
let move_left tape =
  match tape.left with
  | [] -> { tape with left = []; current = tape.blank; right = tape.current :: tape.right }
  | hd :: tl -> { tape with left = tl; current = hd; right = tape.current :: tape.right }

(* Déplace la tête vers la droite *)
let move_right tape =
  match tape.right with
  | [] -> { tape with left = tape.current :: tape.left; current = tape.blank; right = [] }
  | hd :: tl -> { tape with left = tape.current :: tape.left; current = hd; right = tl }

(* Écrit un symbole à la position courante *)
let write tape symbol =
  { tape with current = symbol }

(* Convertit la bande en chaîne pour l'affichage *)
let to_string tape =
  let left_str = List.fold_left (fun acc s -> s ^ acc) "" tape.left in
  let right_str = String.concat "" tape.right in
  Printf.sprintf "[%s<%s>%s]" left_str tape.current right_str
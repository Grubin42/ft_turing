(* Types représentant une machine de Turing *)

(* Action: mouvement de la tête de lecture/écriture *)
type action = Left | Right

(* Transition: règle définissant le comportement de la machine *)
type transition = {
  read: string;      (* Symbole lu sur la bande *)
  to_state: string;  (* État vers lequel la machine va transiter *)
  write: string;     (* Symbole à écrire sur la bande *)
  action: action     (* Direction vers laquelle déplacer la tête *)
}

(* Machine complète de Turing *)
type machine = {
  name: string;                           (* Nom de la machine *)
  alphabet: string list;                  (* Symboles reconnus par la machine *)
  blank: string;                          (* Symbole représentant une case vide *)
  states: string list;                    (* Liste des états possibles *)
  initial: string;                        (* État initial de démarrage *)
  finals: string list;                    (* États d'acceptation/arrêt *)
  transitions: (string * transition list) list  (* Règles de transition par état *)
}
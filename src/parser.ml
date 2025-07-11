open Yojson.Basic.Util  (* Fonctions utilitaires pour manipuler du JSON *)
open Machine            (* Import des types définis pour la machine *)

(* Convertit une chaîne en action (LEFT/RIGHT) *)
let parse_action = function
  | "LEFT" -> Left
  | "RIGHT" -> Right
  | a -> failwith ("Action invalide: " ^ a)  (* Gestion d'erreur *)

(* Parse une transition individuelle depuis un objet JSON *)
let parse_transition json =
  {
    read = json |> member "read" |> to_string;          (* Extrait le symbole à lire *)
    to_state = json |> member "to_state" |> to_string;  (* Extrait l'état suivant *)
    write = json |> member "write" |> to_string;        (* Extrait le symbole à écrire *)
    action = json |> member "action" |> to_string |> parse_action  (* Extrait et convertit l'action *)
  }

(* Parse l'ensemble des transitions depuis le JSON *)
let parse_transitions json =
  (* Convertit en liste d'associations (état -> liste de transitions) *)
  json |> to_assoc |> List.map (fun (state, trans) ->
    (state, trans |> to_list |> List.map parse_transition)
  )

(* Parse le fichier JSON complet et crée l'objet machine *)
let parse_machine filename =
  try
    (* Chargement du fichier JSON *)
    let json = Yojson.Basic.from_file filename in
    
    (* Construction de l'objet machine avec tous ses champs *)
    let machine = {
      name = json |> member "name" |> to_string;
      alphabet = json |> member "alphabet" |> to_list |> List.map to_string;
      blank = json |> member "blank" |> to_string;
      states = json |> member "states" |> to_list |> List.map to_string;
      initial = json |> member "initial" |> to_string;
      finals = json |> member "finals" |> to_list |> List.map to_string;
      transitions = json |> member "transitions" |> parse_transitions
    } in
    
    (* === Validation de la machine === *)
    
    (* Vérifie que le symbole "blank" est dans l'alphabet *)
    if not (List.mem machine.blank machine.alphabet) then
      failwith "Le symbole 'blank' doit être dans l'alphabet";
    
    (* Vérifie que l'état initial est dans la liste des états *)
    if not (List.mem machine.initial machine.states) then
      failwith "L'état initial doit être dans la liste des états";
    
    (* Vérifie que tous les états finaux sont dans la liste des états *)
    List.iter (fun final ->
      if not (List.mem final machine.states) then
        failwith ("L'état final '" ^ final ^ "' doit être dans la liste des états")
    ) machine.finals;

    (* Vérifier que toutes les transitions sont valides *)
    List.iter (fun (state, transitions) ->
      (* L'état source existe-t-il? *)
      if not (List.mem state machine.states) then
        failwith ("Transition: l'état source '" ^ state ^ "' n'existe pas");
        
      List.iter (fun t ->
        (* L'état cible existe-t-il? *)
        if not (List.mem t.to_state machine.states) then
          failwith ("Transition depuis '" ^ state ^ "': l'état cible '" ^ t.to_state ^ "' n'existe pas");
          
        (* Le symbole lu est-il dans l'alphabet? *)
        if not (List.mem t.read machine.alphabet) then
          failwith ("Transition depuis '" ^ state ^ "': le symbole lu '" ^ t.read ^ "' n'est pas dans l'alphabet");
          
        (* Le symbole à écrire est-il dans l'alphabet? *)
        if not (List.mem t.write machine.alphabet) then
          failwith ("Transition depuis '" ^ state ^ "': le symbole à écrire '" ^ t.write ^ "' n'est pas dans l'alphabet")
      ) transitions
    ) machine.transitions;
    
    machine  (* Retourne la machine validée *)
    
  (* === Gestion des erreurs === *)
  with
  | Yojson.Json_error msg -> failwith ("Erreur JSON: " ^ msg)  (* Format JSON incorrect *)
  | Type_error (msg, _) -> failwith ("Erreur de type: " ^ msg)  (* Type incorrect dans le JSON *)
  | e -> failwith ("Erreur: " ^ Printexc.to_string e)  (* Autre erreur *)
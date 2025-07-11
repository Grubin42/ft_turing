open Machine
open Tape

(* Type pour représenter l'état de la machine à un moment donné *)
type configuration = {
  state: string;   (* État courant de la machine *)
  tape: tape;      (* État de la bande *)
}

(* Trouve la transition à appliquer selon l'état courant et le symbole lu *)
let find_transition machine state symbol =
  try
    let transitions = List.assoc state machine.transitions in
    let transition = List.find (fun t -> t.read = symbol) transitions in
    Some transition
  with
  | Not_found -> None  (* Pas de transition trouvée = blocage *)

(* Applique une transition à la configuration actuelle *)
let apply_transition transition config =
  let new_tape = 
    config.tape 
    |> (fun tape -> write tape transition.write)
    |> (match transition.action with
        | Left -> move_left
        | Right -> move_right)
  in
  { state = transition.to_state; tape = new_tape }

(* Effectue un pas de la machine *)
let step machine config =
  match find_transition machine config.state config.tape.current with
  | Some transition ->
      let new_config = apply_transition transition config in
      let step_desc = Printf.sprintf 
        "[%s] (%s, %s) -> (%s, %s, %s)" 
        (to_string config.tape)
        config.state
        config.tape.current
        transition.to_state
        transition.write
        (match transition.action with Left -> "LEFT" | Right -> "RIGHT")
      in
      (new_config, step_desc, true)
  | None ->
      let step_desc = Printf.sprintf 
        "[%s] (%s, %s) -> BLOCAGE: aucune transition définie"
        (to_string config.tape)
        config.state
        config.tape.current
      in
      (config, step_desc, false)

(* Exécute la machine jusqu'à l'arrêt *)
let run machine input =
  Printf.printf "Début de l'exécution de '%s' avec entrée '%s'\n" machine.name input;
  
  (* Initialise la configuration *)
  let initial_tape = make_tape input machine.blank in
  let initial_config = { state = machine.initial; tape = initial_tape } in
  
  let rec run_loop config step_count =
    (* Affiche l'état courant *)
    Printf.printf "Étape %d: [%s] (état: %s)\n" step_count (to_string config.tape) config.state;
    
    (* Vérifie si on est dans un état final *)
    if List.mem config.state machine.finals then
      Printf.printf "Machine arrêtée: état final '%s' atteint après %d étapes\n" config.state step_count
    else
      (* Exécute un pas *)
      let (new_config, step_desc, success) = step machine config in
      Printf.printf "%s\n" step_desc;
      
      if success then
        (* Continue l'exécution *)
        run_loop new_config (step_count + 1)
      else
        (* Blocage *)
        Printf.printf "Machine bloquée après %d étapes\n" step_count
  in
  
  run_loop initial_config 0
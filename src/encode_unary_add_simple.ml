(* encode_unary_add_simple.ml - Encodeur pour la métamachine simplifiée unary_add_metamachine.json *)

let encode_unary_add input =
  (* Format d'encodage : #TABLE#WORD#STATE# *)
  (* Même format que notre ancienne métamachine mais plus simple *)
  
  (* Table des transitions encodées selon unary_add.json *)
  let table = [
    "[A|1|A|1|R];";  (* scan: 1 -> scan, 1, RIGHT *)
    "[A|+|A|.|R];";  (* scan: + -> scan, ., RIGHT *)
    "[A|=|B|.|L];";  (* scan: = -> cleanup, ., LEFT *)
    "[A|.|A|.|R];";  (* scan: . -> scan, ., RIGHT *)
    "[B|1|H|1|R];";  (* cleanup: 1 -> HALT, 1, RIGHT *)
    "[B|.|B|.|L];";  (* cleanup: . -> cleanup, ., LEFT *)
  ] in
  
  (* Encoder le mot d'entrée avec la tête au début *)
  let word = 
    if input = "" then "<.>"
    else 
      let first_char = String.sub input 0 1 in
      let rest = if String.length input > 1 then String.sub input 1 (String.length input - 1) else "" in
      "<" ^ first_char ^ ">" ^ rest
  in
  
  (* État initial mappé : scan = A *)
  let state = "A" in
  
  (* Format final: #TABLE#WORD#STATE# *)
  "#" ^ String.concat "" table ^ "#" ^ word ^ "#" ^ state ^ "#"

let () =
  if Array.length Sys.argv < 2 then (
    Printf.printf "Usage: %s <input>\n" Sys.argv.(0);
    Printf.printf "Exemple: %s \"1+1=\"\n" Sys.argv.(0);
    Printf.printf "\n";
    Printf.printf "🎯 ENCODEUR POUR MÉTAMACHINE SIMPLIFIÉE\n";
    Printf.printf "======================================\n";
    Printf.printf "Encode les opérations d'addition pour unary_add_metamachine.json\n";
    Printf.printf "\n";
    Printf.printf "Format: #TABLE#WORD#STATE#\n";
    Printf.printf "- TABLE: Transitions de unary_add encodées\n";
    Printf.printf "- WORD: Entrée avec tête marquée <symbole>\n";
    Printf.printf "- STATE: État initial (A)\n";
    Printf.printf "\n";
    Printf.printf "Mapping:\n";
    Printf.printf "  scan -> A\n";
    Printf.printf "  cleanup -> B\n";
    Printf.printf "  HALT -> H\n";
    Printf.printf "\n";
    Printf.printf "Avantage: Métamachine 100x plus petite que pseudo_universal !\n";
    exit 1
  ) else (
    let encoded = encode_unary_add Sys.argv.(1) in
    Printf.printf "%s\n" encoded
  )

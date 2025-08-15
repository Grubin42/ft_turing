(* Métamachine progressive : ajoute A|=|B|.|L aux 2 règles qui marchent *)

let () =
  print_endline "{";
  print_endline "  \"name\": \"step_by_step_universal\",";
  print_endline "  \"alphabet\": [\"1\", \"+\", \"=\", \".\", \"#\", \"[\", \"]\", \"|\", \";\", \"A\", \"B\", \"H\", \"L\", \"R\", \"<\", \">\", \"_\"],";
  print_endline "  \"blank\": \"_\",";
  print_endline "  \"states\": [\"INIT\", \"READ_SYMBOL\", \"FIND_STATE\", \"CHECK_A1\", \"CHECK_APLUS\", \"CHECK_AEQ\", \"CHECK_ADOT\", \"CHECK_B1\", \"CHECK_BPLUS\", \"APPLY_A1\", \"APPLY_APLUS\", \"APPLY_AEQ\", \"APPLY_ADOT\", \"APPLY_B1\", \"APPLY_BDOT\", \"MOVE_RIGHT\", \"WRITE_DOT\", \"MOVE_LEFT\", \"PLACE_HEAD\", \"PLACE_HEAD_LEFT\", \"SET_STATE_B\", \"SET_STATE_H\", \"CHECK_FINAL_STATE\", \"CONTINUE\", \"HALT\"],";
  print_endline "  \"initial\": \"INIT\",";
  print_endline "  \"finals\": [\"HALT\"],";
  print_endline "  \"transitions\": {";

  (* INIT - Aller directement à < *)
  print_endline "    \"INIT\": [";
  let all_chars = ["#"; "["; "]"; "A"; "B"; "H"; "1"; "+"; "="; "."; "|"; "L"; "R"; ";"; ">"; "_"] in
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"INIT\", \"write\": \"%s\", \"action\": \"RIGHT\"},\n" c c
  ) all_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"READ_SYMBOL\", \"write\": \"<\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* READ_SYMBOL - Lire le symbole sous la tête *)
  print_endline "    \"READ_SYMBOL\": [";
  print_endline "      {\"read\": \"1\", \"to_state\": \"FIND_STATE\", \"write\": \"1\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"+\", \"to_state\": \"FIND_STATE\", \"write\": \"+\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"=\", \"to_state\": \"FIND_STATE\", \"write\": \"=\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"FIND_STATE\", \"write\": \".\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \">\", \"to_state\": \"READ_SYMBOL\", \"write\": \">\", \"action\": \"RIGHT\"},";
        print_endline "      {\"read\": \"#\", \"to_state\": \"HALT\", \"write\": \"#\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* FIND_STATE - Aller à l'état *)
  print_endline "    \"FIND_STATE\": [";
  let word_chars = [">"; "1"; "+"; "="; "."; "#"] in
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"FIND_STATE\", \"write\": \"%s\", \"action\": \"RIGHT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"A\", \"to_state\": \"CHECK_A1\", \"write\": \"A\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"B\", \"to_state\": \"CHECK_B1\", \"write\": \"B\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"H\", \"to_state\": \"HALT\", \"write\": \"H\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* CHECK_A1 - Vérifier si on a A et le symbole *)
  print_endline "    \"CHECK_A1\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"CHECK_A1\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"CHECK_APLUS\", \"write\": \"<\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* CHECK_APLUS - Vérifier le symbole pour choisir la règle A *)
  print_endline "    \"CHECK_APLUS\": [";
  print_endline "      {\"read\": \"1\", \"to_state\": \"APPLY_A1\", \"write\": \"1\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"+\", \"to_state\": \"APPLY_APLUS\", \"write\": \"+\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"=\", \"to_state\": \"APPLY_AEQ\", \"write\": \"=\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"APPLY_ADOT\", \"write\": \".\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \">\", \"to_state\": \"CHECK_APLUS\", \"write\": \">\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* APPLY_A1 - Appliquer A|1|A|1|R : écrire 1, déplacer RIGHT *)
  print_endline "    \"APPLY_A1\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"APPLY_A1\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"MOVE_RIGHT\", \"write\": \"1\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* APPLY_APLUS - Appliquer A|+|A|.|R : écrire ., déplacer RIGHT *)
  print_endline "    \"APPLY_APLUS\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"APPLY_APLUS\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"WRITE_DOT\", \"write\": \".\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* APPLY_AEQ - Appliquer A|=|B|.|L : écrire ., déplacer LEFT, passer en B *)
  print_endline "    \"APPLY_AEQ\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"APPLY_AEQ\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"MOVE_LEFT\", \"write\": \".\", \"action\": \"LEFT\"}";
  print_endline "    ],";

  (* APPLY_ADOT - Appliquer A|.|A|.|R : écrire ., déplacer RIGHT, rester en A *)
  print_endline "    \"APPLY_ADOT\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"APPLY_ADOT\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"WRITE_DOT\", \"write\": \".\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* CHECK_B1 - Vérifier si on a B et le symbole *)
  print_endline "    \"CHECK_B1\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"CHECK_B1\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"CHECK_BPLUS\", \"write\": \"<\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* CHECK_BPLUS - Vérifier le symbole pour choisir la règle B *)
  print_endline "    \"CHECK_BPLUS\": [";
  print_endline "      {\"read\": \"1\", \"to_state\": \"APPLY_B1\", \"write\": \"1\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"APPLY_BDOT\", \"write\": \".\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \">\", \"to_state\": \"CHECK_BPLUS\", \"write\": \">\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* APPLY_B1 - Appliquer B|1|H|1|R : écrire 1, déplacer RIGHT, aller en H *)
  print_endline "    \"APPLY_B1\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"APPLY_B1\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"SET_STATE_H\", \"write\": \"1\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* APPLY_BDOT - Appliquer B|.|B|.|L : écrire ., déplacer LEFT, rester en B *)
  print_endline "    \"APPLY_BDOT\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"APPLY_BDOT\", \"write\": \"%s\", \"action\": \"LEFT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"MOVE_LEFT\", \"write\": \".\", \"action\": \"LEFT\"}";
  print_endline "    ],";

  (* MOVE_RIGHT - Déplacer la tête vers la droite (pour A|1 et A|+) *)
  print_endline "    \"MOVE_RIGHT\": [";
  print_endline "      {\"read\": \"1\", \"to_state\": \"PLACE_HEAD\", \"write\": \"1\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \">\", \"to_state\": \"PLACE_HEAD\", \"write\": \">\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* WRITE_DOT - Déplacer la tête vers la droite après avoir écrit . (pour A|+ et A|.) *)
  print_endline "    \"WRITE_DOT\": [";
  print_endline "      {\"read\": \"+\", \"to_state\": \"PLACE_HEAD\", \"write\": \"+\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"PLACE_HEAD\", \"write\": \".\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \">\", \"to_state\": \"PLACE_HEAD\", \"write\": \">\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* MOVE_LEFT - Déplacer la tête vers la gauche (pour A|=) *)
  print_endline "    \"MOVE_LEFT\": [";
  print_endline "      {\"read\": \"1\", \"to_state\": \"PLACE_HEAD_LEFT\", \"write\": \"<\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"+\", \"to_state\": \"PLACE_HEAD_LEFT\", \"write\": \"<\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"=\", \"to_state\": \"PLACE_HEAD_LEFT\", \"write\": \"<\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"PLACE_HEAD_LEFT\", \"write\": \"<\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \">\", \"to_state\": \"PLACE_HEAD_LEFT\", \"write\": \"<\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"#\", \"to_state\": \"SET_STATE_B\", \"write\": \"#\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* PLACE_HEAD - Placer < sur le caractère suivant (mouvement RIGHT) *)
  print_endline "    \"PLACE_HEAD\": [";
  print_endline "      {\"read\": \">\", \"to_state\": \"CONTINUE\", \"write\": \"<\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"1\", \"to_state\": \"CONTINUE\", \"write\": \"<\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"+\", \"to_state\": \"CONTINUE\", \"write\": \"<\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"=\", \"to_state\": \"CONTINUE\", \"write\": \"<\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"CONTINUE\", \"write\": \"<\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* PLACE_HEAD_LEFT - Placer > après le symbole précédent (mouvement LEFT) *)
  print_endline "    \"PLACE_HEAD_LEFT\": [";
  print_endline "      {\"read\": \"1\", \"to_state\": \"SET_STATE_B\", \"write\": \">\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"+\", \"to_state\": \"SET_STATE_B\", \"write\": \">\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"=\", \"to_state\": \"SET_STATE_B\", \"write\": \">\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"SET_STATE_B\", \"write\": \">\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"#\", \"to_state\": \"SET_STATE_B\", \"write\": \"#\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* SET_STATE_B - Changer l'état de A vers B *)
  print_endline "    \"SET_STATE_B\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"SET_STATE_B\", \"write\": \"%s\", \"action\": \"RIGHT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"<\", \"to_state\": \"SET_STATE_B\", \"write\": \"<\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"A\", \"to_state\": \"CONTINUE\", \"write\": \"B\", \"action\": \"LEFT\"}";
  print_endline "    ],";

  (* SET_STATE_H - Changer l'état vers H (HALT) *)
  print_endline "    \"SET_STATE_H\": [";
  List.iter (fun c ->
    Printf.printf "      {\"read\": \"%s\", \"to_state\": \"SET_STATE_H\", \"write\": \"%s\", \"action\": \"RIGHT\"},\n" c c
  ) word_chars;
  print_endline "      {\"read\": \"#\", \"to_state\": \"HALT\", \"write\": \"#\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"A\", \"to_state\": \"HALT\", \"write\": \"H\", \"action\": \"RIGHT\"},";
  print_endline "      {\"read\": \"B\", \"to_state\": \"HALT\", \"write\": \"H\", \"action\": \"RIGHT\"}";
  print_endline "    ],";

  (* CHECK_FINAL_STATE - Vérifier si l'état simulé est H (HALT) *)
  print_endline "    \"CHECK_FINAL_STATE\": [";
  print_endline "      {\"read\": \"H\", \"to_state\": \"HALT\", \"write\": \"H\", \"action\": \"RIGHT\"},";  (* État H : vraiment terminer *)
  print_endline "      {\"read\": \"A\", \"to_state\": \"HALT\", \"write\": \"A\", \"action\": \"RIGHT\"},";  (* État A : arrêter (simulation incomplète) *)
  print_endline "      {\"read\": \"B\", \"to_state\": \"HALT\", \"write\": \"B\", \"action\": \"RIGHT\"}";   (* État B : arrêter (simulation incomplète) *)
  print_endline "    ],";

  (* CONTINUE - Placer > sur le caractère suivant et continuer *)
  print_endline "    \"CONTINUE\": [";
  print_endline "      {\"read\": \"+\", \"to_state\": \"INIT\", \"write\": \">\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"=\", \"to_state\": \"INIT\", \"write\": \">\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"1\", \"to_state\": \"INIT\", \"write\": \">\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \".\", \"to_state\": \"INIT\", \"write\": \">\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"A\", \"to_state\": \"INIT\", \"write\": \"A\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"B\", \"to_state\": \"INIT\", \"write\": \"B\", \"action\": \"LEFT\"},";
  print_endline "      {\"read\": \"#\", \"to_state\": \"INIT\", \"write\": \"#\", \"action\": \"LEFT\"}";
  print_endline "    ]";

  print_endline "  }";
  print_endline "}";

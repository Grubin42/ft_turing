open Machine
open Parser
open Simulator

(* Affiche l'aide *)
let print_help () =
  print_endline "usage: ft_turing [-h] jsonfile input";
  print_endline "";
  print_endline "Simule une machine de Turing";
  print_endline "";
  print_endline "Arguments:";
  print_endline "  -h, --help    Affiche ce message d'aide";
  print_endline "  jsonfile      Chemin vers le fichier JSON décrivant la machine";
  print_endline "  input         Entrée à fournir à la machine"

(* Programme principal *)
let () =
  let argc = Array.length Sys.argv in
  
  if argc = 1 then (
    (* Aucun argument *)
    print_help ();
    exit 1
  ) else (
    if argc = 2 then (
      (* Option d'aide ou fichier sans entrée *)
      if Sys.argv.(1) = "-h" || Sys.argv.(1) = "--help" then (
        print_help ();
        exit 0
      ) else (
        Printf.eprintf "Erreur: entrée manquante\n";
        print_help ();
        exit 1
      )
    ) else (
      try
        (* Parse la machine depuis le fichier JSON *)
        let machine = parse_machine Sys.argv.(1) in
        
        (* Affiche les informations de la machine *)
        Printf.printf "Machine '%s' chargée avec succès!\n" machine.name;
        Printf.printf "Alphabet: [%s]\n" (String.concat ", " machine.alphabet);
        Printf.printf "États: [%s]\n" (String.concat ", " machine.states);
        Printf.printf "État initial: %s\n" machine.initial;
        Printf.printf "États finaux: [%s]\n" (String.concat ", " machine.finals);
        
        (* Exécute la machine sur l'entrée fournie *)
        run machine Sys.argv.(2)
      with
      | Failure msg -> Printf.eprintf "Erreur: %s\n" msg; exit 1
    )
  )
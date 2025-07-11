# Planning d’implémentation – Projet ft_turing

## Jour 1 : Lecture et préparation
- Lire attentivement le sujet.
- Comprendre la structure d'une machine de Turing.
- Étudier un exemple de JSON de machine.
- Choisir ton langage fonctionnel (OCaml conseillé).
- Créer l’arborescence du projet + Makefile.

## Jour 2 : Parsing JSON
- Charger et parser le fichier JSON.
- Vérifier la validité de la machine (champs, types, états…).
- Gérer les erreurs avec messages clairs.

## Jour 3-4 : Structure des données
- Définir les types : `state`, `transition`, `machine`, `tape`, etc.
- Représenter la bande et la tête.
- Utiliser des types immuables (listes, tuples…).

## Jour 5-6 : Simulation de la machine
- Implémenter l’algorithme de transition :
  - Lire le symbole courant.
  - Écrire sur la bande.
  - Bouger la tête (gauche/droite).
  - Changer d’état.
- Ajouter affichage (ou log) à chaque transition.
- Gérer l’arrêt (état final ou blocage).

## Jour 7 : Interface CLI
- Ajouter parsing d’arguments (`--help`, fichier JSON, input).
- Tester avec `unary_sub.json`.

## Jour 8 : Machines supplémentaires
- Écrire les 4 autres machines :
  - Addition unaire
  - Palindrome
  - 0ⁿ1ⁿ
  - 0²ⁿ
- Tester chaque machine avec plusieurs entrées.

## Jour 9 : Métamachine (machine n°5)
- Implémenter une machine qui lit une autre machine.
- Représenter alphabet + transitions dans l’entrée.
- Challenge, à aborder une fois le reste stable.

## Jour 10+ : Bonus et polish
- Ajouter le calcul du temps d’exécution (nombre de transitions).
- Améliorer l’affichage/log.
- Nettoyer le code.
- Derniers tests.
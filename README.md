# ft_turing – L'origine de la programmation

## 🧠 Chapitre I – Préface

Voici ce que dit Wikipédia de l’homme qui a créé ton métier :

> **Alan Mathison Turing** était un pionnier britannique de l’informatique, mathématicien, logicien, cryptanalyste, philosophe, biologiste mathématique, ainsi que marathonien et coureur d’ultrafond.  
> Il a fortement influencé le développement de l’informatique en formalisant les concepts d’algorithme et de calcul avec la machine de Turing, considérée comme un modèle d’ordinateur universel.  
> Il est largement reconnu comme le père de l’informatique théorique et de l’intelligence artificielle.  
>  
> Pendant la Seconde Guerre mondiale, Turing a travaillé à Bletchley Park où il a brisé les codes allemands.  
> Ses travaux ont aidé à réduire la durée de la guerre de 2 à 4 ans.  
>  
> En 1952, il a été condamné pour homosexualité (alors criminelle). Il est mort en 1954.  
> Il a été réhabilité officiellement par le gouvernement britannique en 2009, puis par la Reine en 2013.

---

## 🧰 Chapitre II – Introduction

Le projet **ft_turing** consiste à implémenter une **machine de Turing à une bande infinie et une tête**, en **langage fonctionnel**.  
Exemples de définitions mathématiques :  
- [Stanford Encyclopedia](http://plato.stanford.edu/entries/turing-machine)  
- [Cours LIAFA](http://www.liafa.jussieu.fr/~carton/Enseignement/Complexite/MasterInfo/Cours/turing.html)

---

## 🎯 Chapitre III – Objectifs

Créer un programme qui simule une **machine de Turing** à partir d’une **description JSON**.

- Doit être codé en **paradigme fonctionnel**
- OCaml est suggéré, mais tout langage fonctionnel est accepté.
- Usage libre de bibliothèques (pas de lib toute faite).

---

## 📜 Chapitre IV – Règles générales

- Langage libre + bibliothèques standards OK.
- Interdiction d’utiliser des bibliothèques qui « font tout ».
- Pour OCaml :
  - Fournir un `Makefile` compilable avec `ocamlopt`/`ocamlc`
  - Détection et installation automatique des dépendances via OPAM
- Pas de `;;` dans les fichiers.
- Favoriser `map`, `fold`, `iter`, fonctions anonymes, etc.

---

## ✅ Chapitre V – Partie Obligatoire

### V.1 Simulation d'une machine

- Lire un JSON décrivant une machine.
- Simuler les transitions selon les symboles et états.

Exemple de champs JSON :

```json
{
  "name": "unary_sub",
  "alphabet": ["1", ".", "-", "="],
  "blank": ".",
  "states": ["scanright", "eraseone", "subone", "skip", "HALT"],
  "initial": "scanright",
  "finals": ["HALT"],
  "transitions": {
    "scanright": [
      { "read": "=", "to_state": "eraseone", "write": ".", "action": "LEFT" }
    ]
  }
}
```
### Fonctionnalités à implémenter :

- Exécution ligne de commande :
  ./ft_turing --help
  usage: ft_turing [-h] jsonfile input

- Affichage clair de chaque transition :
  Exemple :
  [11<1>-11=...] (scanright, 1) -> (scanright, 1, RIGHT)

- Détection et rejet des entrées ou descriptions invalides
- Détection des blocages de la machine avec un message clair
- Affichage (ou log fichier) de la bande à chaque étape

---

### V.2 Descriptions de machines à créer

1. Addition unaire  
2. Détection de palindrome (écrit 'y' ou 'n' à droite du mot)  
3. Langage 0ⁿ1ⁿ (exemples valides : 000111, 01, 0011)  
4. Langage 0²ⁿ (exemples valides : 00, 0000, mais pas 000)  
5. Métamachine : machine qui lit et exécute la machine d’addition

---

## ⭐ Chapitre VI – Partie Bonus

Bonus évaluable uniquement si la partie obligatoire est intégralement réussie.

Objectif :
- Ajouter une mesure de complexité temporelle :
  - Compter le nombre de transitions effectuées jusqu’à l’arrêt.
  - Optionnel : affichage ou export du temps d’exécution.

⚠ Aucun autre bonus ne sera pris en compte.

---

## 📦 Chapitre VII – Remise et évaluation

- Tu dois remettre le projet dans un dépôt Git.
- Seul le contenu du dépôt sera pris en compte à la soutenance.
- Aucune manipulation locale ne sera acceptée pendant la défense.
- Vérifie le nom des fichiers, répertoires, et le bon fonctionnement du Makefile.

---

## structure projet

```bash
ft_turing/
├── src/
│   ├── parser.ml       # Pour le parsing du JSON
│   ├── machine.ml      # Définition des types et fonctions de la machine
│   ├── tape.ml         # Représentation de la bande
│   ├── simulator.ml    # Simulation des transitions
│   └── main.ml         # Point d'entrée du programme
├── data/
│   └── machines/       # Pour stocker les fichiers JSON des machines
├── _build/             # Dossier de build (généré automatiquement)
├── dune                # Configuration de build pour dune
├── dune-project        # Configuration du projet dune
├── Makefile            # Pour compiler le projet
└── ft_turing.opam      # Définition des dépendances OPAM
```

## exemple cmds

```bash
# Sustraction unaire (11-1=1)
dune exec ft_turing -- data/machines/unary_sub.json "11-1="

# Addition unaire (1+1=11)
dune exec ft_turing -- data/machines/unary_add.json "1+1="

# Palindrome (accepte 101)
dune exec ft_turing -- data/machines/palindrome.json "101"

# Langage 0ⁿ1ⁿ (accepte 000111)
dune exec ft_turing -- data/machines/0n1n.json "000111"

# Langage 0²ⁿ (accepte 0000)
dune exec ft_turing -- data/machines/0_2n.json "0000"
```

Bonne chance, et que Turing soit avec toi.
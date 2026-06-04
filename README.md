# tp_prise_en_main

## Présentation

`tp_prise_en_main` est une application mobile Flutter conçue pour gérer un quiz éducatif avec authentification, navigation, suivi des scores et affichage d'un classement. Le projet inclut plusieurs écrans pour l'inscription, la connexion, le choix de quiz, le jeu, les résultats, l'historique et le tableau de bord des meilleurs scores.

## Fonctionnalités principales

- Authentification utilisateur : inscription et connexion
- Sélection de thèmes de quiz
- Interface de jeu interactive avec questions et réponses
- Calcul du score et affichage du résultat
- Historique des jeux joués
- Classement des meilleurs joueurs
- Design responsive pour mobile et web

## Ce que l'application peut faire

- Permettre à un utilisateur de s'inscrire avec un nouveau compte
- Permettre à un utilisateur de se connecter avec ses identifiants
- Afficher un écran d'accueil (`Home`) avec navigation vers les différentes sections
- Proposer un quiz selon un thème choisi
- Lancer le jeu de quiz et afficher les questions une à une
- Calculer le score final et présenter un écran de résultat
- Afficher le classement (`Leaderboard`) des meilleurs scores
- Consulter l'historique des parties jouées

## Structure du projet

- `lib/main.dart` : point d'entrée de l'application
- `lib/pages.dart` : routes et pages principales
- `lib/models/` : définitions des classes métier (question, thème, utilisateur)
- `lib/screens/` : écrans de l'application
  - `home_screen.dart`
  - `leaderboard_screen.dart`
  - `login_screen.dart`
  - `main_navigation.dart`
  - `quiz_game_screen.dart`
  - `quiz_history_screen.dart`
  - `quiz_result_screen.dart`
  - `quiz_screen.dart`
  - `register_screen.dart`
- `lib/services/` : services applicatifs et logique métier
- `lib/widgets/` : composants UI réutilisables
- `lib/helpers/` : utilitaires comme `theme_icon_helper.dart`

## Installation

1. Assurez-vous d'avoir Flutter installé et configuré sur votre machine.
2. Ouvrez un terminal dans le dossier du projet :
   ```bash
   cd c:\wamp64\www\MyDigitalSchool\Flutter\tp_prise_en_main
   ```
3. Installez les dépendances Flutter :
   ```bash
   flutter pub get
   ```
4. Lancez l'application sur un simulateur ou un appareil :
   ```bash
   flutter run
   ```

## Organisation du code

- Les écrans (`screens`) affichent l'interface et gèrent la navigation.
- Les modèles (`models`) représentent les données de l'application.
- Les services (`services`) encapsulent la logique de traitement et la récupération des données.
- Les widgets (`widgets`) contiennent des composants UI réutilisables.

## Développement

- Pour ajouter un nouveau thème de quiz, enrichissez `lib/models/quiz_theme.dart` et `lib/models/quiz_theme_items.dart`.
- Pour créer de nouvelles questions de quiz, modifiez `lib/models/quiz_question.dart` ou le service dédié.
- Pour étendre le flow de navigation, mettez à jour `lib/pages.dart` et `lib/screens/main_navigation.dart`.

## Notes

- Le projet est prêt pour une extension vers des services backend, une base de données locale ou une API.
- La structure suit les bonnes pratiques Flutter avec une séparation claire entre UI, modèles et services.

## Auteur

Projet développé dans le cadre d'un TP Flutter.

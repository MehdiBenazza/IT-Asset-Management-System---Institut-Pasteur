# IT Asset Management System - Institut Pasteur

Système de gestion du parc informatique pour l'Institut Pasteur développé en Flutter avec Supabase.

## Structure du Projet

```
lib/
├─ core/
│  ├─ config/            # Configuration (env, clés Supabase, constantes)
│  │  └─ app_config.dart
│  ├─ routing/           # Gestion des routes et navigation
│  ├─ theme/             # Thèmes, couleurs, typographie
│  ├─ utils/             # Utilitaires (validateurs, dates, logger)
│  │  ├─ validators.dart
│  │  └─ date_utils.dart
│  ├─ errors/            # Gestion des exceptions et erreurs
│  ├─ widgets/           # Widgets réutilisables (AppScaffold, EmptyState)
│  └─ services/
│     ├─ supabase_client.dart   # Client Supabase singleton
│     └─ pdf_service.dart       # Génération de rapports PDF
│
├─ features/
│  ├─ auth/              # Authentification
│  │  ├─ data/
│  │  │  ├─ auth_repository.dart
│  │  │  └─ auth_remote.dart
│  │  ├─ domain/
│  │  │  └─ entities.dart
│  │  └─ presentation/
│  │     ├─ login_screen.dart
│  │     └─ auth_controller.dart
│  │
│  ├─ users/             # Gestion des utilisateurs
│  │  ├─ data/
│  │  │  ├─ user_repository.dart
│  │  │  └─ user_remote.dart
│  │  ├─ domain/
│  │  │  ├─ user.dart
│  │  │  └─ usecases.dart
│  │  └─ presentation/
│  │     ├─ users_screen.dart
│  │     ├─ user_form.dart
│  │     └─ users_controller.dart
│  │
│  ├─ materiel/          # Gestion du matériel informatique
│  │  ├─ data/
│  │  │  ├─ materiel_repository.dart
│  │  │  ├─ materiel_remote.dart
│  │  │  └─ materiel_mapper.dart
│  │  ├─ domain/
│  │  │  ├─ materiel.dart
│  │  │  └─ usecases.dart
│  │  └─ presentation/
│  │     ├─ materiel_list_screen.dart
│  │     ├─ materiel_detail_screen.dart
│  │     ├─ materiel_form.dart
│  │     └─ materiel_controller.dart
│  │
│  ├─ intervention/      # Gestion des interventions techniques
│  │  ├─ data/
│  │  │  ├─ intervention_repository.dart
│  │  │  ├─ intervention_remote.dart
│  │  │  └─ intervention_mapper.dart
│  │  ├─ domain/
│  │  │  ├─ intervention.dart
│  │  │  └─ usecases.dart
│  │  └─ presentation/
│  │     ├─ intervention_list_screen.dart
│  │     ├─ intervention_form.dart
│  │     └─ intervention_controller.dart
│  │
│  ├─ appartenance/      # Gestion des affectations de matériel
│  │  ├─ data/
│  │  │  ├─ appartenance_repository.dart
│  │  │  ├─ appartenance_remote.dart
│  │  │  └─ appartenance_mapper.dart
│  │  ├─ domain/
│  │  │  ├─ appartenance.dart
│  │  │  └─ usecases.dart
│  │  └─ presentation/
│  │     ├─ appartenance_list_screen.dart
│  │     ├─ appartenance_form.dart
│  │     └─ appartenance_controller.dart
│  │
│  └─ localisation/      # Gestion des localisations
│     ├─ data/
│     ├─ domain/
│     └─ presentation/
│
├─ app.dart              # Configuration principale de l'application
└─ main.dart             # Point d'entrée et initialisation
```

## Architecture

Le projet suit une architecture **Clean Architecture** avec séparation des couches :

### Domain Layer
- **Entities** : Modèles de données purs
- **Use Cases** : Logique métier

### Data Layer
- **Repository** : Interface entre le domaine et les données
- **Remote** : Appels API Supabase
- **Mapper** : Conversion DTO ↔ Entity

### Presentation Layer
- **Screens** : Écrans de l'interface utilisateur
- **Controllers** : Gestion de l'état (ViewModel)

## Fonctionnalités

### 🔐 Authentification
- Connexion avec email/mot de passe
- Gestion des sessions utilisateur
- Récupération de mot de passe

### 👥 Gestion des Utilisateurs
- CRUD utilisateurs
- Gestion des rôles (Admin, Technicien, Utilisateur)
- Profils utilisateur

### 💻 Gestion du Matériel
- Inventaire du parc informatique
- Suivi des équipements
- Statuts (Actif, Maintenance, Hors service)
- Transferts de localisation

### 🔧 Interventions Techniques
- Création d'interventions
- Suivi des maintenances
- Signatures administratives
- Génération de rapports PDF

### 📋 Affectations
- Attribution de matériel aux utilisateurs
- Historique des affectations
- Transferts entre utilisateurs

## Technologies Utilisées

- **Flutter** : Framework UI
- **Supabase** : Backend-as-a-Service
- **PostgreSQL** : Base de données
- **Riverpod/Bloc** : Gestion d'état (à implémenter)

## Configuration

1. **Variables d'environnement** :
   ```dart
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

2. **Dépendances** (à ajouter dans pubspec.yaml) :
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     supabase_flutter: ^1.10.0
     intl: ^0.18.0
     pdf: ^3.10.0
   ```

## Installation

1. Cloner le repository
2. Installer les dépendances : `flutter pub get`
3. Configurer les variables d'environnement
4. Lancer l'application : `flutter run`

## Base de Données Supabase

### Tables principales :
- `users` : Utilisateurs du système
- `materiel` : Inventaire du matériel
- `interventions` : Interventions techniques
- `appartenances` : Affectations matériel-utilisateur
- `localisations` : Lieux de stockage

## Développement

### Conventions de nommage :
- **Fichiers** : snake_case
- **Classes** : PascalCase
- **Variables** : camelCase
- **Constantes** : UPPER_SNAKE_CASE

### Structure des commits :
- `feat:` Nouvelle fonctionnalité
- `fix:` Correction de bug
- `refactor:` Refactoring
- `docs:` Documentation
- `test:` Tests

## Contribution

1. Fork le projet
2. Créer une branche feature
3. Commiter les changements
4. Pousser vers la branche
5. Créer une Pull Request

## Licence

Projet interne - Institut Pasteur




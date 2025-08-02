# Structure du Projet - IT Asset Management System

## 📁 Architecture Générale

```
lib/
├── core/                           # Couche partagée
│   ├── config/                     # Configuration
│   │   ├── app_config.dart
│   │   └── routes.dart
│   ├── enums/                      # Enums globaux
│   │   └── app_enums.dart
│   ├── models/                     # Export centralisé
│   │   └── models.dart
│   ├── services/                   # Services partagés
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart
│   │   └── supabase_service.dart
│   ├── utils/                      # Utilitaires
│   └── widgets/                    # Widgets communs
│       └── common_widgets.dart
├── features/                       # Fonctionnalités métier
│   ├── auth/                       # Authentification
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── departement/                # Gestion des départements
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── bureau/                     # Gestion des bureaux
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── users/                      # Gestion des utilisateurs
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── materiel/                   # Gestion du matériel
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── appartenance/               # Affectations matériel-utilisateur
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── localisation/               # Localisation du matériel
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/
│   │       └── widgets/
│   └── intervention/               # Interventions de maintenance
│       ├── data/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
├── main.dart                       # Point d'entrée
└── app.dart                        # Configuration de l'app
```

## 🧪 Structure des Tests

```
test/
├── unit/                           # Tests unitaires
│   ├── models/                     # Tests des modèles
│   │   └── departement_test.dart
│   └── services/                   # Tests des services
│       └── supabase_service_test.dart
├── widget/                         # Tests de widgets
│   └── departement_list_page_test.dart
├── integration/                    # Tests d'intégration
│   └── app_flow_test.dart
└── models_test.dart                # Tests généraux des modèles
```

## 🏗️ Architecture Clean

### Domain Layer (Couche Métier)
- **Modèles** : Entités métier pures
- **Use Cases** : Logique métier
- **Repositories Interfaces** : Contrats d'accès aux données

### Data Layer (Couche Données)
- **Repositories** : Implémentation des repositories
- **DataSources** : Sources de données (API, Base de données)
- **Models** : Modèles de données (si différents des domain models)

### Presentation Layer (Couche Présentation)
- **Pages** : Écrans de l'application
- **Widgets** : Composants réutilisables
- **Controllers** : Gestion d'état (Riverpod, Bloc, etc.)

## 📋 Modèles de Données

### Enums
- `RoleEnum` : superadmin, admin, secretaire, employe
- `EtatMaterielEnum` : actif, enPanne, enReparation
- `TypeInterventionEnum` : preventive, corrective

### Entités Principales
1. **Departement** : Départements de l'institut
2. **Bureau** : Bureaux appartenant aux départements
3. **User** : Utilisateurs du système
4. **Materiel** : Équipements informatiques
5. **Appartenance** : Historique des affectations
6. **Localisation** : Historique des emplacements
7. **Intervention** : Interventions de maintenance

## 🔧 Services Partagés

- **SupabaseService** : Gestion de la base de données
- **AuthService** : Authentification et autorisation
- **StorageService** : Stockage local et cache

## 🎯 Prochaines Étapes

1. **Implémenter les repositories** pour chaque feature
2. **Créer les datasources** pour Supabase
3. **Développer les pages** de l'interface utilisateur
4. **Ajouter les contrôleurs** pour la gestion d'état
5. **Écrire les tests** pour chaque couche
6. **Configurer la navigation** et les routes

## 📚 Bonnes Pratiques

- ✅ Séparation claire des responsabilités
- ✅ Architecture feature-first
- ✅ Modèles immutables avec JSON serialization
- ✅ Tests organisés par type
- ✅ Services partagés dans core/
- ✅ Widgets réutilisables
- ✅ Configuration centralisée 
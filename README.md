#  GuideMe — L'Uber des guides touristiques locaux
**GuideMe** est une application mobile Flutter née d'un projet sur l'uberisation des services. L'idée est simple : permettre à n'importe quel touriste de trouver un guide local indépendant en quelques clics.

##  Le Concept

Trouver un bon guide local est souvent un casse-tête (prix opaques, disponibilité incertaine, barrière de la langue). 
Cette plateforme connecte deux types d'utilisateurs :
* **Le Touriste :** Cherche un guide selon son budget, sa langue et sa destination.
* **Le Guide :** Propose ses services, gère ses réservations et valide ses prestations.

---

##  Architecture & Clean Code
```text
lib/
├── core/                # Global utilities, configs and services
├── features/
│   ├── auth/            # Authentication feature
│   ├── guides/          # Tourist guide feature
│   │   ├── data/        # Mock data sources
│   │   ├── domain/      # Entities and business models
│   │   └── presentation/# UI pages and widgets
│   ├── booking/         # Guide reservation
│   ├── payment/         # Payment simulation
│   └── reviews/         # Guide rating system
└── shared/              # Shared UI components
```
### Structure du projet :
* **`core/`** : Configuration globale, thèmes et services partagés.
* **`features/`** : Le cœur de l'app découpé par fonctionnalités (Auth, Booking, Guides, Payment, Reviews). Chaque feature possède ses propres couches *Data*, *Domain* et *Presentation*.
* **`shared/`** : Composants UI réutilisables (boutons, cartes, champs de saisie).

**Stack technique :**
* **Framework :** Flutter 
* **State Management :** Bloc / Flutter Bloc
* **Navigation :** GoRouter
* **Données :** Utilisation de sources "Mock" pour valider le flux utilisateur complet.

---

##  Fonctionnalités du MVP

### Côté Voyageur :
- [x] Inscription et connexion sécurisée.
- [x] Recherche multicritères (Destination, Budget, Langue).
- [x] Consultation des profils détaillés des guides.
- [x] Réservation en temps réel et simulation de paiement.
- [x] Système d'évaluation (avis et notes) après la prestation.

### Côté Guide :
- [x] Réception et gestion des demandes de réservation.
- [x] Validation de la fin de mission.
- [x] Suivi simplifié des revenus (simulation).

---

##  Installation et Test

Pour lancer le projet sur votre machine :

1.  **Cloner le dépôt**
    ```bash
    git clone [https://github.com/VOTRE_NOM/NOM_PROJET.git](https://github.com/VOTRE_NOM/NOM_PROJET.git)
    ```
2.  **Installer les dépendances**
    ```bash
    flutter pub get
    ```
3.  **Lancer l'application**
    ```bash
    flutter run
    ```

---

## Objectif du projet

Ce projet démontre comment une interface mobile peut transformer un service traditionnel en une marketplace dynamique. L'objectif était de simplifier l'interaction humaine tout en garantissant une structure technique solide et prête pour une mise en production réelle (intégration backend).



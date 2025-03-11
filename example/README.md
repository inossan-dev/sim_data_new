# Exemple d'application SIM Data

Cette application d'exemple montre comment utiliser le plugin SIM Data pour récupérer et afficher les informations des cartes SIM sur un appareil Android.

## Fonctionnalités démontrées

- Demande de permission READ_PHONE_STATE
- Récupération des données des cartes SIM
- Affichage des informations dans une interface utilisateur Flutter
- Gestion des erreurs et des permissions refusées

## Exécution de l'exemple

1. Clonez le dépôt
2. Naviguez vers le dossier `example`
3. Exécutez `flutter pub get`
4. Connectez un appareil Android
5. Exécutez `flutter run`

## Structure du code

- `main.dart` - Point d'entrée de l'application et interface utilisateur
- `android/` - Configuration spécifique à Android
    - Manifeste avec les permissions requises
    - Configuration Gradle

## Points importants

### Vérification de la permission

Le plugin tente de demander automatiquement la permission READ_PHONE_STATE, mais il est recommandé d'implémenter votre propre logique de vérification des permissions pour une meilleure expérience utilisateur.

### Gestion des erreurs

L'exemple montre comment gérer les erreurs potentielles lors de la récupération des données SIM et comment permettre à l'utilisateur de réessayer.

### Interface utilisateur adaptative

L'interface s'adapte au nombre de cartes SIM présentes dans l'appareil, en affichant les détails pertinents pour chaque carte.
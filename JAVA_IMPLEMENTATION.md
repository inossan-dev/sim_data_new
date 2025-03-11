# Documentation technique - Implémentation Java

Ce document détaille l'implémentation Java du plugin SIM Data pour Flutter.

## Vue d'ensemble

Le plugin utilise l'API `SubscriptionManager` d'Android pour accéder aux informations des cartes SIM. Il implémente les interfaces Flutter nécessaires pour permettre l'interaction entre le code Dart et le code natif Android.

## Classes principales

### SimDataPlugin

La classe principale qui implémente les interfaces Flutter et gère les communications entre Flutter et Android.

```java
public class SimDataPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, RequestPermissionsResultListener {
    // Implémentation
}
```

#### Interfaces implémentées

- **FlutterPlugin**: Pour s'intégrer à l'écosystème de plugins Flutter
- **MethodCallHandler**: Pour gérer les appels de méthodes depuis Flutter
- **ActivityAware**: Pour accéder à l'activité Android actuelle, nécessaire pour les demandes de permission
- **RequestPermissionsResultListener**: Pour recevoir les résultats des demandes de permission

#### Méthodes clés

##### `onAttachedToEngine`
Appelée lorsque le plugin est attaché au moteur Flutter. Initialise les canaux de communication.

##### `onMethodCall`
Appelée lorsqu'une méthode est invoquée depuis Flutter. Traite la méthode `getSimData` et gère les erreurs.

##### `getSimData`
Méthode privée qui accède à l'API Android pour récupérer les informations des cartes SIM.

##### `requestPermission` et `checkPermission`
Méthodes qui gèrent la demande et la vérification de la permission `READ_PHONE_STATE`.

##### `onRequestPermissionsResult`
Reçoit le résultat de la demande de permission et continue le traitement si la permission est accordée.

## Flux de données

1. L'application Flutter appelle `SimDataPlugin.getSimData()` en Dart
2. La requête est transmise via MethodChannel au code natif
3. La méthode `onMethodCall` vérifie la permission READ_PHONE_STATE
4. Si la permission est accordée, la méthode `getSimData` est appelée
5. La méthode accède à l'API SubscriptionManager pour récupérer les informations
6. Les données sont converties en JSON
7. Le résultat JSON est renvoyé à travers le canal Flutter
8. Le code Dart convertit le JSON en objets Dart

## Gestion des permissions

Le plugin utilise l'API de permission d'Android pour demander et vérifier la permission `READ_PHONE_STATE`. Si la permission n'est pas accordée, le plugin la demande automatiquement. Si l'utilisateur refuse la permission, une erreur est renvoyée à Flutter.

### Flux de permission

1. Vérification si la permission est déjà accordée avec `checkPermission()`
2. Si non, sauvegarde du résultat en attente et appel de `requestPermission()`
3. Quand l'utilisateur répond, `onRequestPermissionsResult` est appelé
4. Si la permission est accordée, le traitement continue
5. Sinon, une erreur est renvoyée à Flutter

## Structure JSON

Le plugin renvoie une structure JSON qui contient un tableau de cartes SIM:

```json
{
  "cards": [
    {
      "carrierName": "Opérateur",
      "countryCode": "FR",
      "displayName": "Nom affiché",
      "isDataRoaming": false,
      "isNetworkRoaming": false,
      "mcc": 208,
      "mnc": 15,
      "phoneNumber": "+33612345678",
      "serialNumber": "12345678901234567890",
      "slotIndex": 0,
      "subscriptionId": 1
    },
    // Autres cartes SIM...
  ]
}
```

## Considérations de sécurité

- Le plugin requiert la permission `READ_PHONE_STATE`, qui est considérée comme sensible par Android
- Les données des cartes SIM peuvent contenir des informations personnelles (numéro de téléphone)
- Le plugin ne transmet aucune donnée à des serveurs externes
- Toutes les données restent dans l'appareil de l'utilisateur

## Compatibilité

- Testé avec Android API 23 (Marshmallow) jusqu'à API 33 (Android 13)
- Requiert au minimum Android 6.0 (API 23) en raison de l'utilisation du système de permission au runtime
- Compatible avec les appareils mono et multi-SIM

## Optimisations

- Gestion des erreurs robuste
- Vérification des valeurs nulles pour éviter les crashes
- Caching des résultats en attente lors des demandes de permission

## Limitations connues

- Ne fonctionne que sur Android (pas de support iOS)
- Certains fabricants peuvent limiter l'accès à certaines informations
- Certains appareils peuvent ne pas renvoyer le numéro de téléphone
- Les émulateurs peuvent ne pas fournir toutes les informations
# Guide de test pour SIM Data Plugin

Ce document explique comment exécuter les tests pour le plugin SIM Data afin de vérifier son bon fonctionnement.

## Types de tests

Le plugin SIM Data comporte deux types de tests:

1. **Tests unitaires**: Vérifient le comportement des modèles de données et les interactions simulées avec la plateforme native
2. **Tests d'intégration**: Vérifient le fonctionnement du plugin sur un appareil réel

## Exécution des tests unitaires

Les tests unitaires se trouvent dans le dossier `test/` à la racine du projet. Pour les exécuter:

```bash
cd sim_data
flutter test
```

Ces tests vérifient:
- La conversion JSON vers objets Dart
- La gestion des erreurs et des cas limites
- Le fonctionnement des méthodes principales

## Exécution des tests d'intégration

Les tests d'intégration se trouvent dans le dossier `example/integration_test/`. Pour les exécuter, vous avez besoin d'un appareil Android physique ou d'un émulateur connecté:

```bash
cd sim_data/example
flutter test integration_test/sim_data_integration_test.dart
```

Ces tests vérifient:
- La communication avec les API natives d'Android
- La récupération des données SIM réelles
- Le rendu de l'interface utilisateur basé sur les données récupérées

> **Note**: Les tests d'intégration nécessitent que vous accordiez manuellement la permission READ_PHONE_STATE à l'application de test lors de son exécution.

## Interprétation des résultats

### Pour les tests unitaires

Un test unitaire réussi affichera un résultat similaire à:

```
00:01 +4: All tests passed!
```

### Pour les tests d'intégration

Un test d'intégration réussi affichera des informations sur les cartes SIM détectées (si disponibles) et se terminera par:

```
All tests passed!
```

Si vous n'avez pas accordé la permission ou si aucune carte SIM n'est présente dans l'appareil, le test affichera des informations sur l'erreur mais réussira quand même, car il vérifie que l'erreur est correctement gérée.

## Couverture des tests

Pour générer un rapport de couverture des tests unitaires:

```bash
cd sim_data
flutter test --coverage
```

Cela générera un fichier `lcov.info` dans le dossier `coverage/`. Vous pouvez utiliser des outils comme `lcov` ou `genhtml` pour générer un rapport HTML:

```bash
genhtml coverage/lcov.info -o coverage/html
```

## Cas de test spécifiques

### Test de permission refusée

Pour tester le comportement lorsque la permission est refusée:
1. Exécutez l'application exemple
2. Refusez la permission lorsqu'elle est demandée
3. Vérifiez que l'application affiche correctement un message d'erreur

### Test avec plusieurs cartes SIM

Si vous avez accès à un appareil avec plusieurs cartes SIM:
1. Insérez plusieurs cartes SIM dans l'appareil
2. Exécutez l'application exemple
3. Vérifiez que toutes les cartes SIM sont correctement détectées et affichées

### Test de gestion des erreurs

Pour tester la gestion des erreurs, vous pouvez modifier temporairement le code Java pour simuler des erreurs:

```java
// Dans SimDataPlugin.java, modifiez getSimData()
private JSONObject getSimData() throws Exception {
    // Simuler une erreur
    throw new Exception("Erreur simulée pour le test");
}
```

Puis vérifiez que l'application gère correctement cette erreur.
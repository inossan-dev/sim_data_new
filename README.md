# SIM Data

Un plugin Flutter pour récupérer les informations des cartes SIM sur Android (support multi-SIM).

## Fonctionnalités

- Récupération des informations détaillées des cartes SIM
- Support des appareils multi-SIM
- Compatible avec les dernières versions de Flutter
- Gestion optimisée des permissions Android

## Installation

```yaml
dependencies:
  sim_data: ^1.0.0
```

Puis exécutez:

```bash
flutter pub get
```

## Configuration requise

### Android

Dans le fichier `android/app/src/main/AndroidManifest.xml`, ajoutez la permission nécessaire:

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

Le plugin gère automatiquement la demande de permission à l'exécution, mais vous devez déclarer la permission dans le manifeste.

### iOS

Ce plugin n'est actuellement pas disponible pour iOS en raison des restrictions d'Apple sur l'accès aux informations du téléphone.

## Utilisation

```dart
import 'package:sim_data_new/sim_data.dart';

// Récupérer les données des cartes SIM
Future<void> getSimData() async {
  try {
    SimData simData = await SimDataPlugin.getSimData();
    
    // Accéder aux informations des cartes SIM
    for (var card in simData.cards) {
      print('Opérateur: ${card.carrierName}');
      print('Numéro: ${card.phoneNumber}');
      print('Pays: ${card.countryCode}');
      print('MCC: ${card.mcc}');
      print('MNC: ${card.mnc}');
      print('Slot: ${card.slotIndex}');
      print('--------------------');
    }
  } catch (e) {
    print('Erreur lors de la récupération des données SIM: $e');
  }
}
```

## Exemple complet

Un exemple complet est disponible dans le dossier `/example`. Voici un aperçu:

```dart
import 'package:flutter/material.dart';
import 'package:sim_data_new/sim_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sim Data Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sim Data Demo')),
        body: const SimDataScreen(),
      ),
    );
  }
}

class SimDataScreen extends StatefulWidget {
  const SimDataScreen({Key? key}) : super(key: key);

  @override
  _SimDataScreenState createState() => _SimDataScreenState();
}

class _SimDataScreenState extends State<SimDataScreen> {
  SimData? _simData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSimData();
  }

  Future<void> _loadSimData() async {
    try {
      final simData = await SimDataPlugin.getSimData();
      setState(() {
        _simData = simData;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Erreur: $_error'),
            ElevatedButton(
              onPressed: _loadSimData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_simData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _simData!.cards.length,
      itemBuilder: (context, index) {
        final card = _simData!.cards[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SIM ${index + 1}', style: Theme.of(context).textTheme.headline6),
                Text('Opérateur: ${card.carrierName}'),
                Text('Numéro: ${card.phoneNumber}'),
                Text('Pays: ${card.countryCode}'),
                Text('MCC+MNC: ${card.mcc}-${card.mnc}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

## Informations disponibles

Pour chaque carte SIM, vous pouvez accéder aux informations suivantes:

| Propriété | Description |
|-----------|-------------|
| `carrierName` | Nom de l'opérateur |
| `displayName` | Nom affiché de la carte SIM |
| `countryCode` | Code pays ISO |
| `mcc` | Mobile Country Code |
| `mnc` | Mobile Network Code |
| `phoneNumber` | Numéro de téléphone associé à la SIM |
| `slotIndex` | Index du slot de la carte SIM |
| `serialNumber` | Numéro de série (ICCID) |
| `subscriptionId` | ID de l'abonnement |
| `isDataRoaming` | Si le roaming de données est activé |
| `isNetworkRoaming` | Si la carte est en roaming réseau |

## Résolution des problèmes

### La permission est refusée

Le plugin tente automatiquement de demander la permission `READ_PHONE_STATE`. Si l'utilisateur refuse la permission, une exception sera levée. Vous devez implémenter votre propre logique pour informer l'utilisateur et le rediriger vers les paramètres de l'application pour accorder la permission.

### Plugin FlutterPlugin.onAttachedToEngine

Si vous rencontrez des erreurs liées à FlutterPlugin.onAttachedToEngine, cela peut indiquer un problème de compatibilité avec votre version de Flutter. Assurez-vous d'utiliser la dernière version du plugin compatible avec votre version de Flutter.

## Contributions

Les contributions sont les bienvenues! N'hésitez pas à ouvrir un problème ou une pull request sur GitHub.

## Licence

Ce plugin est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
# Guide de mise à niveau de SIM Data

Ce document fournit des instructions détaillées pour mettre à niveau le plugin [SIM Data](https://pub.dev/packages/sim_data "A Flutter plugin to retrieve Sim cards data - dual sim support - only Android for now.") de la version 0.0.2+1 vers la version 0.1.0, compatible avec les versions récentes de Flutter et Android.

## Résumé des changements

La mise à niveau comprend:
- Mise à jour des dépendances Flutter
- Mise à jour de la configuration Gradle pour Android
- Amélioration de la gestion des permissions
- Modernisation des modèles de données Dart
- Mise à jour des manifestes Android pour la compatibilité Android 12+

## Étapes détaillées

### 1. Mise à jour de pubspec.yaml

```yaml
name: sim_data
description: A Flutter plugin to retrieve Sim cards data - dual sim support - only Android for now.
version: 1.0.0
homepage: https://github.com/inossan-dev/sim_data_new.git
documentation: https://github.com/inossan-dev/sim_data_new.git
repository: https://github.com/inossan-dev/sim_data_new.git
issue_tracker: https://github.com/inossan-dev/sim_data_new/issues

environment:
  sdk: ">=2.18.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.1

flutter:
  plugin:
    platforms:
      android:
        package: com.ino.sim_data_new
        pluginClass: SimDataPlugin
```

### 2. Mise à jour des fichiers Gradle

#### build.gradle

```gradle
group 'com.ino.sim_data_new'
version '1.0'

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.2'
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

apply plugin: 'com.android.library'

android {
    compileSdkVersion 33

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        minSdkVersion 23
    }

    namespace 'com.ino.sim_data_new'
}
```

#### gradle-wrapper.properties

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

### 3. Mise à jour du manifeste Android

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
</manifest>
```

### 4. Mise à jour de la classe Java du plugin

Les principales modifications de la classe Java comprennent:
- Mise à jour des imports pour AndroidX
- Amélioration de la gestion des permissions
- Gestion améliorée des erreurs
- Prévention des NullPointerException

### 5. Mise à jour des modèles Dart

Les modifications incluent:
- Utilisation de constructeurs nommés
- Utilisation de paramètres requis
- Meilleure gestion des valeurs nulles
- Implémentation de méthodes toString() pour faciliter le débogage

### 6. Mise à jour de la structure du projet exemple

Pour l'application exemple:
- Mise à jour des manifestes Android
- Ajout de l'attribut android:exported="true"
- Mise à jour de la configuration Gradle
- Mise à jour du code Dart pour utiliser les nouvelles API

## Problèmes courants et solutions

### Permission READ_PHONE_STATE refusée

Si la permission est refusée, implémentez une meilleure expérience utilisateur en expliquant pourquoi la permission est nécessaire et comment l'accorder.

### Erreur avec android:exported dans AndroidManifest.xml

À partir d'Android 12, chaque activité avec un intent-filter doit spécifier explicitement android:exported. Assurez-vous que votre manifeste a:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    ...
```

### Incompatibilité Gradle/Java

Si vous rencontrez des erreurs comme "Unsupported class file major version", mettez à jour votre gradle-wrapper.properties pour utiliser une version de Gradle compatible avec votre version de Java:

- Java 8: Gradle 6.3+
- Java 11: Gradle 6.5+
- Java 17: Gradle 7.3+

## Publication sur pub.dev

### Préparation

1. Mettez à jour les fichiers nécessaires:
   - README.md
   - CHANGELOG.md
   - pubspec.yaml
   - LICENSE

2. Vérifiez la conformité du package:
   ```bash
   flutter pub publish --dry-run
   ```

3. Corrigez les problèmes éventuels signalés

### Publication

```bash
flutter pub publish
```

Vous pouvez également publier depuis la ligne de commande avec un jeton d'accès personnel pour automatiser le processus dans les systèmes CI/CD.
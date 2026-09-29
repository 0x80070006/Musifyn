# Musifyn

Client musical Android pour un serveur Jellyfin personnel, développé avec Flutter.

**État :** démonstration en développement. Un APK v1.0.2 est publié ; la compilation du dépôt et le fonctionnement avec un serveur Jellyfin réel n'ont pas été vérifiés pendant cet audit. Les fichiers de version dans le projet indiquent toujours `1.0.0`.

## Télécharger

[Télécharger l'APK v1.0.2](https://github.com/0x80070006/Musifyn/releases/download/v1.0.2/Musifyn-v1.0.2.apk) · [Toutes les versions](https://github.com/0x80070006/Musifyn/releases)

Les fichiers téléchargeables portent désormais le même nom et le même numéro que leur release.

![Aperçu Musifyn](musifyn.png)

## Fonctionnalités présentes dans les sources

- Connexion à un serveur Jellyfin et navigation dans la bibliothèque musicale.
- Lecture audio, playlists, recherche et écran de lecture.
- Stockage local des préférences et des données de connexion.

## Construire

Prérequis : Flutter, Dart et Android SDK.

```bash
flutter pub get
flutter build apk --debug
```

L'APK est normalement créée dans `build/app/outputs/flutter-apk/`. Le dépôt ne fournit pas de workflow de compilation automatique ; une ancienne documentation décrivait un exemple de workflow sans qu'il soit présent dans le dépôt.

## Technologies

| Rôle | Dépendances déclarées |
| --- | --- |
| Application | Flutter / Dart, `provider` |
| Serveur Jellyfin | `http` |
| Lecture | `just_audio` |
| Images | `cached_network_image`, `image_picker` |
| Stockage local | `shared_preferences`, `flutter_secure_storage` |
| Utilitaires | `crypto` |

Les contraintes de version se trouvent dans [pubspec.yaml](pubspec.yaml).

## Configuration et confidentialité

Un serveur Jellyfin accessible depuis le téléphone est nécessaire. Saisissez son adresse et vos identifiants dans l'application ; ne les ajoutez jamais au dépôt. L'application communique avec le serveur configuré et peut conserver des informations de connexion sur l'appareil. Préférez HTTPS et vérifiez la configuration réseau du serveur.

## Licence

Code sous licence MIT : [LICENSE](LICENSE). Les ressources et services tiers conservent leurs propres conditions.

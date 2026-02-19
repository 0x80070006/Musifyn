# Musifyn - Client Jellyfin pour Android

## 🎵 Fonctionnalités
- Connexion à n'importe quel serveur Jellyfin (IP + port + login/mdp)
- Interface style Spotify (thème sombre, dégradés bleu/violet)
- Lecture audio complète avec contrôles (play/pause, précédent, suivant)
- Barre de progression interactive
- Mini-player persistant
- Navigation : Accueil, Recherche, Bibliothèque, Playlists
- Bibliothèque : Artistes, Albums, Favoris
- Recherche de musique en temps réel
- Création et gestion de playlists locales
- Ajout aux favoris
- Répétition (off / all / one) et lecture aléatoire
- Sessions persistantes (reconnexion automatique)

---

## 🚀 Compiler l'APK (méthode rapide)

### Prérequis
- Flutter SDK installé : https://flutter.dev/docs/get-started/install
- Android Studio ou SDK Android (API 21+)
- Java 11 ou supérieur

### Étapes

```bash
# 1. Aller dans le dossier du projet
cd musifyn

# 2. Récupérer les dépendances
flutter pub get

# 3. Compiler l'APK
flutter build apk --release

# L'APK se trouve dans :
# build/app/outputs/flutter-apk/app-release.apk
```

### Alternative : APK debug (plus rapide, pas besoin de signer)
```bash
flutter build apk --debug
```

---

## 📱 Installer sur Android

```bash
# Avec ADB (câble USB, USB debug activé)
adb install build/app/outputs/flutter-apk/app-release.apk

# Ou copier directement le fichier APK sur le téléphone
# et l'installer manuellement (activer "Sources inconnues")
```

---

## 🔧 Compilation via GitHub Actions (sans installer Flutter)

Créez `.github/workflows/build.yml` dans votre repo GitHub :

```yaml
name: Build APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: musifyn-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Structure du projet

```
musifyn/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── models/
│   │   └── media_item_model.dart    # Modèle de données
│   ├── services/
│   │   ├── jellyfin_service.dart    # API Jellyfin
│   │   ├── player_service.dart      # Lecteur audio
│   │   └── playlist_service.dart   # Playlists locales
│   ├── screens/
│   │   ├── login_screen.dart        # Connexion
│   │   ├── home_screen.dart         # Navigation principale
│   │   ├── home_tab.dart            # Onglet accueil
│   │   ├── library_screen.dart      # Bibliothèque
│   │   ├── search_screen.dart       # Recherche
│   │   ├── playlists_screen.dart    # Playlists
│   │   ├── album_screen.dart        # Vue album
│   │   └── player_screen.dart       # Lecteur plein écran
│   └── widgets/
│       ├── mini_player.dart         # Mini lecteur
│       ├── album_card.dart          # Carte album
│       └── track_tile.dart          # Ligne de piste
└── android/                         # Config Android
```

---

## ⚙️ Configuration Jellyfin requise
- Jellyfin Server v10.8 ou supérieur
- Accessible en réseau local (HTTP) ou distant (HTTPS)
- Bibliothèque musicale configurée dans Jellyfin

## 🔗 Format de l'adresse serveur
- Local : `http://192.168.1.x:8096`
- Domaine : `https://jellyfin.mondomaine.com`
- Ne pas mettre de `/` à la fin

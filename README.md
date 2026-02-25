<div align="center">

![Musifyn Banner](musifyn_banner.svg)
<br/><br/>
# Musifyn

**Le client Jellyfin musical qui fait croasser vos enceintes.**  
Interface inspirée de Spotify · Thème vert néon · Bulles animées · 100% open source

[![Updated Badge](https://badges.pufler.dev/updated/0x80070006/Musifyn)](https://badges.pufler.dev)
<br/>

[![Version](https://img.shields.io/badge/version-1.0.0-1DB954?style=for-the-badge&logo=github&logoColor=white)](https://github.com/musifyn/musifyn/releases)
[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-5.0+-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![Jellyfin](https://img.shields.io/badge/Jellyfin-10.8+-00A4DC?style=for-the-badge&logo=jellyfin&logoColor=white)](https://jellyfin.org)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen?style=for-the-badge)](CONTRIBUTING.md)

<br/>

[![Status](https://img.shields.io/badge/Statut-En%20développement%20actif-orange?style=flat-square)]()
[![Platform](https://img.shields.io/badge/Plateforme-Android%20%7C%20iOS%20bientôt-blue?style=flat-square)]()
[![AGP](https://img.shields.io/badge/AGP-8.9.1-1DB954?style=flat-square)]()
[![Gradle](https://img.shields.io/badge/Gradle-8.11.1-02303A?style=flat-square&logo=gradle)]()
[![Kotlin](https://img.shields.io/badge/Kotlin-2.1.0-7F52FF?style=flat-square&logo=kotlin)]()

</div>

---

<div align="center">

### 📥 Télécharger

| Plateforme | Statut | Lien |
|:---:|:---:|:---:|
| 🤖 **Android APK** | ✅ Disponible | [![Télécharger](https://img.shields.io/badge/⬇️_Télécharger-v1.0.0-brightgreen?style=for-the-badge)](https://github.com/0x80070006/Musifyn/releases/tag/app) |
| 🪟 **Windows EXE** | 🔜 Bientôt | — |
| 🍎 **iOS** | 📋 Prévu | — |

</div>

---
![Musifyn fanart](musifyn.png)
## ✨ Aperçu

<div align="center">
  
| Accueil | Mix Genre | Lecteur | Playlists |
|:---:|:---:|:---:|:---:|
| ![Accueil](https://placehold.co/160x320/0A1A0F/1DB954?text=🏠+Accueil&font=monospace) | ![Mix](https://placehold.co/160x320/0A1A0F/1DB954?text=🎵+Mix&font=monospace) | ![Player](https://placehold.co/160x320/0A1A0F/1DB954?text=▶+Player&font=monospace) | ![Playlists](https://placehold.co/160x320/0A1A0F/1ED760?text=🎶+Playlists&font=monospace) |
| Sections dynamiques | Tracklist complète | Plein écran | Édition avancée |

</div>

---

## 🚀 Fonctionnalités

### 🔗 Connexion & Serveur
- Connexion à n'importe quel serveur **Jellyfin 10.8+** via IP/domaine + port
- Authentification sécurisée avec **token persistant** (SharedPreferences)
- Déconnexion propre depuis le profil utilisateur
- Support **HTTP et HTTPS**, cleartext autorisé pour réseau local

### 🏠 Accueil Spotify-like
- **Grille 4×2** des albums et playlists récemment écoutés
- **Carrousel de mix** générés depuis vos **genres Jellyfin réels**
- **12+ sections défilables** : albums, artistes, titres récents, découvertes, favoris, compilations, singles…
- Toutes les données viennent **exclusivement de votre serveur** Jellyfin
- Header compact avec salutation contextuelle (matin / après-midi / soir 🌅☀️🌙)

### 🎵 Mix Intelligents
- Détection automatique de vos **genres musicaux** depuis l'API Jellyfin
- Chaque mix charge **20 titres aléatoires** du genre correspondant
- **Écran détail** avec tracklist : numéro, pochette, titre, artiste, durée
- **Indicateur animé** (3 barres pulsantes) sur le titre en cours de lecture
- Lancement depuis n'importe quel titre de la liste
- Bouton **lecture aléatoire** (shuffle) intégré

### ▶️ Lecteur Audio
- Lecteur plein écran style Spotify avec **grande pochette**
- **Barre de progression** interactive (seek au toucher)
- **3 modes de répétition** : désactivé → répéter tout 🔁 → répéter 1 🔂
- **Shuffle** — lecture aléatoire dans la queue courante
- Contrôles : ⏮ Précédent · ⏯ Play/Pause · ⏭ Suivant
- Bouton ❤️ favoris synchronisé avec Jellyfin
- Ajout rapide à une playlist locale

### 📻 Mini Player Persistant
- Visible sur toutes les pages, fond **verre dépoli** (backdrop blur)
- **Barre de progression verte** cliquable en haut (seek direct)
- Bouton **🔁 répétition** cyclique avec indicateur visuel (point vert)
- Contrôles complets : ⏮ · ⏯ · ⏭
- Tap pour ouvrir le lecteur plein écran

### 🎶 Playlists Locales
- Création, renommage et suppression de playlists
- **Sélecteur d'image** depuis le stockage de l'appareil 📷
- **10 couleurs** de fond personnalisables : vert · bleu · rouge · jaune · violet · noir · rose · cyan · orange · blanc
- Icône **✏️ crayon** pour éditer (au lieu des 3 points classiques)
- Panel d'édition avec **aperçu live** de l'avatar
- **Popup de confirmation** avant toute suppression
- Réorganisation par **drag & drop**
- Suppression d'un titre par **swipe gauche**

### 🔍 Recherche
- Recherche en **temps réel** avec debounce 500ms
- Résultats groupés : **Artistes · Albums · Titres**
- Lecture directe depuis les résultats

### 📚 Bibliothèque
- Onglets : **Artistes** · **Albums** · **Favoris**
- Navigation vers la discographie complète d'un artiste
- Favoris synchronisés avec Jellyfin

### 🎨 Design & Animations
- Thème **vert Spotify** `#1DB954` sur fond noir profond
- **18 bulles animées** qui remontent avec ondulation sinusoïdale unique par bulle
- Navigation sans header, bottom nav avec **flou d'arrière-plan**
- Police **Super Wonder** pour le titre Musifyn
- Logo **grenouille + note de musique** 100% Flutter (CustomPainter)
- Icône launcher identique au logo de l'app, déclinée en 5 densités

---

## 🏗️ Architecture

```
musifyn/
├── lib/
│   ├── main.dart                     # Entrée, thème, AuthGate
│   ├── models/
│   │   └── media_item_model.dart     # Modèle unifié Audio/Album/Artiste
│   ├── services/
│   │   ├── jellyfin_service.dart     # API Jellyfin complète (30+ méthodes)
│   │   ├── player_service.dart       # Lecteur audio (just_audio + queue)
│   │   └── playlist_service.dart    # Playlists locales (JSON/SharedPrefs)
│   ├── screens/
│   │   ├── login_screen.dart         # Connexion serveur
│   │   ├── main_shell.dart           # Shell + bottom nav bar flouté
│   │   ├── home_tab.dart             # Accueil (grille + carrousel + 12 sections)
│   │   ├── search_screen.dart        # Recherche temps réel
│   │   ├── library_screen.dart       # Bibliothèque artistes/albums/favoris
│   │   ├── playlists_screen.dart     # Gestion playlists + éditeur complet
│   │   ├── album_screen.dart         # Détail album + tracklist
│   │   ├── mix_detail_screen.dart    # Détail mix genre + indicateur animation
│   │   └── player_screen.dart        # Lecteur plein écran
│   └── widgets/
│       ├── bubble_background.dart    # 18 bulles animées (ondulation unique)
│       ├── frog_logo.dart            # Logo grenouille (CustomPainter)
│       ├── mini_player.dart          # Barre lecture persistante + progress
│       ├── track_tile.dart           # Tuile titre avec menu contextuel
│       └── album_card.dart           # Carte album
├── android/
│   ├── app/build.gradle              # compileSdk 36, minSdk 21
│   ├── settings.gradle               # AGP 8.9.1, Kotlin 2.1.0
│   └── gradle/wrapper/
│       └── gradle-wrapper.properties # Gradle 8.11.1
├── assets/
│   └── fonts/SuperWonder.ttf         # Police titre app
└── pubspec.yaml                       # Dépendances
```

---

## 🛠️ Stack Technique

| Technologie | Version | Rôle |
|---|---|---|
| **Flutter** | 3.16+ | Framework UI multiplateforme |
| **Dart** | 3.0+ | Langage |
| **just_audio** | 0.9.36 | Moteur de lecture audio |
| **provider** | 6.1.1 | Gestion d'état (ChangeNotifier) |
| **http** | 1.1.0 | Appels API Jellyfin |
| **shared_preferences** | 2.2.0 | Persistance locale (sessions, playlists) |
| **flutter_secure_storage** | 9.0.0 | Stockage sécurisé des tokens |
| **cached_network_image** | 3.3.0 | Cache images réseau |
| **image_picker** | 1.0.4 | Sélection image pochette playlist |
| **crypto** | 3.0.3 | Hashage authentification Jellyfin |
| **Android Gradle Plugin** | 8.9.1 | Build Android |
| **Gradle** | 8.11.1 | Outil de build |
| **Kotlin** | 2.1.0 | MainActivity Android |

---

## ⚙️ Installation & Compilation

### Prérequis

| Outil | Version | Lien |
|---|---|---|
| Flutter SDK | 3.16+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Android Studio | Récent | Avec SDK Android (compileSdk 36) |
| Java | 17+ | Requis par Gradle 8.11.1 |
| Jellyfin | 10.8+ | Avec une bibliothèque musicale configurée |

### Étapes

```bash
# 1. Cloner
git clone https://github.com/musifyn/musifyn.git
cd musifyn

# 2. Dépendances
flutter pub get

# 3. Debug (avec appareil/émulateur connecté)
flutter run

# 4. APK release
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk

# 5. App Bundle (Google Play)
flutter build appbundle --release
# → build/app/outputs/bundle/release/app-release.aab
```

---

## ☁️ Build CI/CD via GitHub Actions

```yaml
# .github/workflows/build.yml
name: Build APK

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: musifyn-release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 30
```

---

## 📡 Configuration Jellyfin

### Format URL serveur

```
✅  http://192.168.1.100:8096
✅  https://jellyfin.mondomaine.fr
✅  http://192.168.1.100:8096/jellyfin   (sous-chemin)
❌  192.168.1.100:8096                   (sans http://)
❌  http://192.168.1.100:8096/           (slash final)
```

### Permissions requises

| Permission | Obligatoire |
|---|---|
| Accès bibliothèques musicales | ✅ |
| Lecture des médias | ✅ |
| Gestion des favoris | ✅ |
| Gestion des playlists Jellyfin | ⚙️ Optionnel |

---

## 🎨 Design System

### Palette

| Rôle | Hex | |
|---|---|---|
| **Primary** — vert Spotify | `#1DB954` | 🟢 |
| **Secondary** — vert clair | `#1ED760` | 💚 |
| **Tertiary** — vert foncé | `#148A3C` | 🌿 |
| **Background** | `#080808` | ⬛ |
| **Surface** | `#181818` | 🔳 |
| **Dark surface** | `#0A1A0F` | 🌑 |
| **Text primary** | `#FFFFFF` | ⬜ |
| **Text muted** | `#9A9A9A` | 🩶 |

### Typographie

| Usage | Police | Taille |
|---|---|---|
| Titre app | **Super Wonder** | 22–38px |
| Titres sections | System Bold w800 | 18px |
| Titres pistes | System SemiBold w600 | 12–14px |
| Métadonnées | System Regular | 10–12px |

### Animations

| Élément | Description |
|---|---|
| Bulles de fond | 18 bulles, vitesse/amplitude/phase uniques, ondulation sinusoïdale |
| Indicateur lecture | 3 barres pulsantes asynchrones (400/520/640ms) |
| Backdrop blur | `BackdropFilter` sigmaX/Y=20 sur nav bar, mini player, header |
| Transitions | `MaterialPageRoute` natif |

---

## 🗺️ Roadmap

### ✅ v1.0.0 — Actuelle
- [x] Connexion Jellyfin (HTTP/HTTPS)
- [x] Interface Spotify-like vert/noir
- [x] Fond animé 18 bulles flottantes
- [x] Logo grenouille + note de musique
- [x] Police Super Wonder
- [x] Accueil : grille récents + carrousel mix + 12 sections
- [x] Mix par genre depuis Jellyfin (+ fallback aléatoire)
- [x] Écran détail mix + tracklist + indicateur animé
- [x] Lecteur plein écran (progress, shuffle, repeat, favoris)
- [x] Mini player persistant (progress, repeat, prev/pause/next)
- [x] Playlists locales (image, couleur, drag&drop, swipe)
- [x] Recherche temps réel
- [x] Bibliothèque (artistes / albums / favoris)

### 🔜 v1.1.0
- [ ] Paroles synchronisées (LRC)
- [ ] Égaliseur audio
- [ ] Widget Android sur l'écran d'accueil
- [ ] Mode hors-ligne (cache des pistes)
- [ ] Support ChromeCast / AirPlay

### 📋 v1.2.0+
- [ ] Support iOS / macOS
- [ ] Thèmes personnalisables
- [ ] Import/Export playlists
- [ ] Statistiques d'écoute
- [ ] Support multi-serveurs Jellyfin

---

## 🤝 Contribuer

```bash
# Forker → Branche → Commit → PR
git checkout -b feature/ma-super-fonctionnalite
git commit -m "feat: description claire"
git push origin feature/ma-super-fonctionnalite
# → Ouvrir une Pull Request
```

### Convention commits

| Préfixe | Usage |
|---|---|
| `feat:` | Nouvelle fonctionnalité |
| `fix:` | Correction de bug |
| `style:` | Changements UI uniquement |
| `refactor:` | Refactoring sans impact fonctionnel |
| `docs:` | Documentation |
| `chore:` | Maintenance, dépendances, CI |

---

## 🐛 Bugs connus & Solutions

| Problème | Cause | Solution |
|---|---|---|
| `ic_launcher not found` | Icônes manquantes | Régénérer les icônes dans `res/mipmap-*/` |
| Build échoue sur `compileSdk 35` | SDK trop bas | Passer à `compileSdk 36` |
| Avertissement AGP 8.3 | Version dépréciée | Mettre à jour AGP 8.9.1 |
| `Gradle 8.11` incompatible | Version exacte requise | Utiliser `8.11.1` (pas `8.11`) |
| Images ne chargent pas | Permission réseau manquante | Vérifier `usesCleartextTraffic=true` dans Manifest |
| Connexion échoue | URL mal formée | Sans slash final, avec `http://` |

---

## 📄 Licence

```
MIT License — Copyright (c) 2026 Musifyn Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED.
```

---

## 🙏 Remerciements

| Projet | Rôle |
|---|---|
| [Jellyfin](https://jellyfin.org) | Serveur média open source — le cœur de l'app |
| [Flutter](https://flutter.dev) | Framework UI multiplateforme |
| [just_audio](https://pub.dev/packages/just_audio) | Moteur audio Flutter |
| [Spotify](https://spotify.com) | Inspiration design & UX |
| [Super Wonder](https://www.dafont.com) | Police typographique du titre |

---
contributeurs : 
[![Contributors Display](https://badges.pufler.dev/contributors/0x80070006/Musifyn?size=50&padding=5&perRow=10&bots=true)](https://badges.pufler.dev)
<div align="center">

**Fait avec 🐸 et beaucoup de musique**

[![GitHub stars](https://img.shields.io/github/stars/musifyn/musifyn?style=social)](https://github.com/musifyn/musifyn)
[![GitHub forks](https://img.shields.io/github/forks/musifyn/musifyn?style=social)](https://github.com/musifyn/musifyn/fork)
[![GitHub issues](https://img.shields.io/github/issues/musifyn/musifyn?style=social)](https://github.com/musifyn/musifyn/issues)

<br/>


*Musifyn n'est affilié ni à Jellyfin ni à Spotify.*

</div>

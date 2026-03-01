<div align="center">

<!-- LOGO / TITRE -->
<img src="https://img.shields.io/badge/-%F0%9F%8E%B5%20MUSIFYN-7B2FBE?style=for-the-badge&logoColor=white&labelColor=0D0D1A" alt="Musifyn" height="60"/>

<br/>
<br/>

**Client Jellyfin musical, style Spotify — sombre & violet**

<br/>

![Version](https://img.shields.io/badge/version-1.0.0--demo-7B2FBE?style=flat-square)
![Statut](https://img.shields.io/badge/statut-démo%20%2F%20en%20développement-orange?style=flat-square)
![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=flat-square&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-5.0%2B-3DDC84?style=flat-square&logo=android&logoColor=white)
![Jellyfin](https://img.shields.io/badge/Jellyfin-10.8%2B-00A4DC?style=flat-square&logo=jellyfin&logoColor=white)
![Licence](https://img.shields.io/badge/licence-MIT-blue?style=flat-square)

<br/>

---

> [!WARNING]
> **🚧 VERSION DÉMO — EN DÉVELOPPEMENT ACTIF 🚧**
>
> Musifyn est actuellement en phase de démonstration. Le code source est disponible pour que vous puissiez compiler l'application vous-même.  
> Les binaires précompilés **(APK Android & EXE Windows)** seront publiés prochainement dans les [Releases](../../releases).

---

</div>

<br/>

## 📸 Aperçu

<div align="center">

| Connexion | Accueil | Lecteur |
|:---------:|:-------:|:-------:|
| <img src="https://placehold.co/180x320/0D0D1A/7B2FBE?text=%F0%9F%94%90+Login%0A%0ADEMO&font=roboto" width="160"/> | <img src="https://placehold.co/180x320/0D0D1A/7B2FBE?text=%F0%9F%8F%A0+Accueil%0A%0ADEMO&font=roboto" width="160"/> | <img src="https://placehold.co/180x320/1A0533/4A90D9?text=%F0%9F%8E%A7+Player%0A%0ADEMO&font=roboto" width="160"/> |
| <img src="https://placehold.co/180x320/0D0D1A/7B2FBE?text=%F0%9F%94%8D+Recherche%0A%0ADEMO&font=roboto" width="160"/> | <img src="https://placehold.co/180x320/0D0D1A/4A90D9?text=%F0%9F%93%9A+Biblio%0A%0ADEMO&font=roboto" width="160"/> | <img src="https://placehold.co/180x320/0D0D1A/7B2FBE?text=%F0%9F%8E%B6+Playlists%0A%0ADEMO&font=roboto" width="160"/> |

*Les captures d'écran seront remplacées par les vraies interfaces lors de la sortie officielle.*

</div>

<br/>

---

## 📦 Téléchargement

<div align="center">

| Plateforme | Statut | Lien |
|:----------:|:------:|:----:|
| 📱 **Android (APK)** | 🔜 Bientôt disponible | [Voir les Releases](../../releases) |
| 🖥️ **Windows (EXE)** | 🛠️ En développement | — |
| 🍎 **iOS / macOS** | 📋 Prévu | — |

</div>

> En attendant la release officielle, vous pouvez **compiler l'APK vous-même** en 3 commandes — voir la section [Compiler soi-même](#-compiler-lapk-soi-même).

<br/>

---

## ✨ Fonctionnalités

<table>
<tr>
<td width="50%">

**🔐 Connexion & Session**
- Saisie libre de l'adresse IP, port, login et mot de passe
- Session persistante (reconnexion automatique)
- Déconnexion propre depuis le profil

**🎧 Lecture audio**
- Streaming direct depuis Jellyfin
- Play / Pause / Suivant / Précédent
- Barre de progression interactive
- Répétition : off / album / titre
- Lecture aléatoire (shuffle)

**📻 Mini-player**
- Toujours visible pendant la navigation
- Contrôles rapides sans quitter l'écran en cours

</td>
<td width="50%">

**🏠 Navigation style Spotify**
- Accueil : albums récents & derniers ajouts
- Recherche temps réel (titres, albums, artistes)
- Bibliothèque : Artistes, Albums, Favoris
- Vue artiste avec discographie complète
- Vue album avec tracklist numérotée

**🎶 Playlists locales**
- Créer, renommer, supprimer
- Ajouter / retirer des titres
- Réorganiser par glisser-déposer
- Lecture depuis n'importe quelle position

**❤️ Favoris**
- Synchronisés directement avec Jellyfin
- Accessibles depuis la bibliothèque

</td>
</tr>
</table>

<br/>

---

## 🎨 Design

Musifyn adopte un thème **100% sombre** avec des dégradés bleu/violet :

| Rôle | Couleur | Code |
|------|---------|------|
| Fond principal | ⬛ | `#080812` |
| Accent violet | 🟣 | `#7B2FBE` |
| Accent bleu | 🔵 | `#4A90D9` |
| Surfaces | 🟦 | `#12122A` |
| Texte secondaire | 🔘 | `#8888AA` |

<br/>

---

## 🚀 Compiler l'APK soi-même

### Prérequis

| Outil | Version minimale | Lien |
|-------|:---------------:|------|
| Flutter SDK | 3.0+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Android SDK | API 21 (Android 5.0) | [Android Studio](https://developer.android.com/studio) |
| Java | 11+ | Inclus avec Android Studio |

### En 3 commandes

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Compiler l'APK release
flutter build apk --release

# 3. Récupérer l'APK ici :
#    build/app/outputs/flutter-apk/app-release.apk
```

> **Mode debug** (pas besoin de signer, plus rapide) :
> ```bash
> flutter build apk --debug
> ```

### Installer sur le téléphone

```bash
# Via ADB (USB debug activé sur le téléphone)
adb install build/app/outputs/flutter-apk/app-release.apk
```

Ou copiez directement l'APK sur votre téléphone et installez-le *(pensez à activer "Sources inconnues" dans les paramètres Android)*.

<br/>

---

## ☁️ Compiler via GitHub Actions (sans Flutter installé)

Forkez le repo puis créez `.github/workflows/build.yml` :

```yaml
name: Build Musifyn APK

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'

      - name: Installer les dépendances
        run: flutter pub get

      - name: Compiler l'APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: musifyn-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

L'APK sera disponible dans l'onglet **Actions → Artifacts** de votre repo.

<br/>

---

## 📁 Structure du projet

```
musifyn/
├── lib/
│   ├── main.dart                      # Point d'entrée & thème global
│   ├── models/
│   │   └── media_item_model.dart      # Modèle de données unifié
│   ├── services/
│   │   ├── jellyfin_service.dart      # API Jellyfin (auth, stream, search…)
│   │   ├── player_service.dart        # Lecteur audio (just_audio)
│   │   └── playlist_service.dart      # Playlists locales (SharedPreferences)
│   ├── screens/
│   │   ├── login_screen.dart          # Écran de connexion
│   │   ├── home_screen.dart           # Navigation principale (BottomNav)
│   │   ├── home_tab.dart              # Onglet Accueil
│   │   ├── library_screen.dart        # Bibliothèque + ArtistScreen
│   │   ├── search_screen.dart         # Recherche temps réel
│   │   ├── playlists_screen.dart      # Playlists + PlaylistDetailScreen
│   │   ├── album_screen.dart          # Vue album avec tracklist
│   │   └── player_screen.dart         # Lecteur plein écran
│   └── widgets/
│       ├── mini_player.dart           # Barre de lecture persistante
│       ├── album_card.dart            # Carte album (grille / liste)
│       └── track_tile.dart            # Ligne de piste avec menu contextuel
└── android/
    └── app/
        ├── build.gradle               # Configuration build Android
        └── src/main/
            ├── AndroidManifest.xml    # Permissions & déclaration d'activité
            └── kotlin/…/MainActivity.kt
```

<br/>

---

## ⚙️ Configuration Jellyfin

```
✅ Jellyfin Server v10.8 ou supérieur
✅ Bibliothèque musicale configurée dans Jellyfin
✅ Accessible en réseau local (HTTP) ou distant (HTTPS)
```

**Format de l'adresse serveur :**

```
Local   →  http://192.168.1.42:8096
Distant →  https://jellyfin.mondomaine.com
```

> ⚠️ Ne pas mettre de `/` à la fin de l'URL.

<br/>

---

## 🗺️ Roadmap

- [x] Authentification Jellyfin
- [x] Streaming audio natif
- [x] Navigation Accueil / Recherche / Bibliothèque / Playlists
- [x] Lecteur plein écran style Spotify
- [x] Mini-player persistant
- [x] Playlists locales (CRUD + réorganisation)
- [x] Favoris synchronisés avec Jellyfin
- [ ] **APK release publique** *(bientôt)*
- [ ] **Version Windows EXE** *(en développement)*
- [ ] File d'attente de lecture éditable
- [ ] Paroles synchronisées (LRC / plugin Jellyfin)
- [ ] Widget Android (contrôles depuis l'écran verrouillé)
- [ ] Égaliseur audio
- [ ] Thèmes de couleur personnalisables

<br/>

---

## 🤝 Contribuer

Les contributions sont les bienvenues !

1. **Forkez** le projet
2. Créez une branche : `git checkout -b feature/ma-fonctionnalite`
3. Committez : `git commit -m 'feat: ajout de X'`
4. Poussez : `git push origin feature/ma-fonctionnalite`
5. Ouvrez une **Pull Request**

Pour signaler un bug ou proposer une idée → [Issues](../../issues)

<br/>

---

## 📄 Licence

Ce projet est distribué sous licence **MIT** — voir [LICENSE](LICENSE) pour les détails.

<br/>

---

<div align="center">

Fait avec ❤️ et Flutter · Propulsé par [Jellyfin](https://jellyfin.org)

*Musifyn n'est pas affilié à Jellyfin ni à Spotify.*

</div>

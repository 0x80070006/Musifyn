<div align="center">

<!-- ═══════════════════════════════════════════════════════ -->
<!--                  BANNIÈRE PRINCIPALE                    -->
<!-- ═══════════════════════════════════════════════════════ -->

<svg width="800" height="160" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#0D0A2E;stop-opacity:1"/>
      <stop offset="50%" style="stop-color:#1A0A4E;stop-opacity:1"/>
      <stop offset="100%" style="stop-color:#0A0A3A;stop-opacity:1"/>
    </linearGradient>
    <linearGradient id="noteGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#7B2FBE;stop-opacity:1"/>
      <stop offset="100%" style="stop-color:#4A90D9;stop-opacity:1"/>
    </linearGradient>
    <filter id="glow"><feGaussianBlur stdDeviation="4" result="coloredBlur"/><feMerge><feMergeNode in="coloredBlur"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
    <filter id="tglow"><feGaussianBlur stdDeviation="3" result="coloredBlur"/><feMerge><feMergeNode in="coloredBlur"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="800" height="160" rx="18" fill="url(#bgGrad)"/>
  <!-- Particules -->
  <circle cx="50" cy="40" r="2" fill="#7B2FBE" opacity="0.5"/>
  <circle cx="750" cy="120" r="3" fill="#4A90D9" opacity="0.4"/>
  <circle cx="700" cy="30" r="1.5" fill="#7B2FBE" opacity="0.6"/>
  <circle cx="100" cy="130" r="2" fill="#4A90D9" opacity="0.4"/>
  <circle cx="650" cy="80" r="1" fill="#fff" opacity="0.3"/>
  <circle cx="160" cy="55" r="1.5" fill="#fff" opacity="0.2"/>
  <circle cx="400" cy="20" r="1" fill="#7B2FBE" opacity="0.4"/>
  <circle cx="580" cy="140" r="2" fill="#4A90D9" opacity="0.3"/>
  <!-- Portées gauche -->
  <g opacity="0.15" stroke="#7B2FBE" stroke-width="1">
    <line x1="30" y1="55" x2="120" y2="55"/><line x1="30" y1="63" x2="120" y2="63"/>
    <line x1="30" y1="71" x2="120" y2="71"/><line x1="30" y1="79" x2="120" y2="79"/>
    <line x1="30" y1="87" x2="120" y2="87"/>
  </g>
  <!-- Portées droite -->
  <g opacity="0.15" stroke="#4A90D9" stroke-width="1">
    <line x1="680" y1="55" x2="770" y2="55"/><line x1="680" y1="63" x2="770" y2="63"/>
    <line x1="680" y1="71" x2="770" y2="71"/><line x1="680" y1="79" x2="770" y2="79"/>
    <line x1="680" y1="87" x2="770" y2="87"/>
  </g>
  <!-- Note musicale double croche -->
  <g transform="translate(108, 33)" filter="url(#glow)">
    <rect x="0" y="10" width="4" height="55" rx="2" fill="url(#noteGrad)"/>
    <rect x="22" y="0" width="4" height="55" rx="2" fill="url(#noteGrad)"/>
    <rect x="0" y="10" width="26" height="5" rx="2.5" fill="url(#noteGrad)"/>
    <rect x="0" y="20" width="26" height="5" rx="2.5" fill="url(#noteGrad)"/>
    <ellipse cx="5" cy="68" rx="9" ry="6" transform="rotate(-15 5 68)" fill="url(#noteGrad)"/>
    <ellipse cx="27" cy="58" rx="9" ry="6" transform="rotate(-15 27 58)" fill="url(#noteGrad)"/>
  </g>
  <!-- MUSIFYN -->
  <text x="430" y="98" font-family="Arial Black, Arial, sans-serif" font-size="62" font-weight="900" fill="#FFFFFF" text-anchor="middle" letter-spacing="6" filter="url(#tglow)">MUSIFYN</text>
  <!-- Sous-titre -->
  <text x="430" y="128" font-family="Arial, sans-serif" font-size="13" fill="#8888CC" text-anchor="middle" letter-spacing="3" opacity="0.85">CLIENT JELLYFIN MUSICAL</text>
  <!-- Bordure -->
  <rect width="800" height="160" rx="18" fill="none" stroke="url(#noteGrad)" stroke-width="1.5" opacity="0.4"/>
</svg>

<br/>
<br/>

<!-- BADGES PRINCIPAUX -->
[![Version](https://img.shields.io/badge/version-1.0.0--demo-7B2FBE?style=flat-square&logo=github&logoColor=white)](../../releases)
[![Statut](https://img.shields.io/badge/statut-en%20développement-orange?style=flat-square&logo=github-actions&logoColor=white)](../../releases)
[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Android](https://img.shields.io/badge/Android-5.0%2B-3DDC84?style=flat-square&logo=android&logoColor=white)](../../releases)
[![Jellyfin](https://img.shields.io/badge/Jellyfin-10.8%2B-00A4DC?style=flat-square&logo=jellyfin&logoColor=white)](https://jellyfin.org)
[![Licence MIT](https://img.shields.io/badge/licence-MIT-blue?style=flat-square&logo=opensourceinitiative&logoColor=white)](LICENSE)

<br/>

<!-- STATS REPO (remplace TONUSER/musifyn par ton vrai repo) -->
![GitHub stars](https://img.shields.io/github/stars/TONUSER/musifyn?style=flat-square&logo=github&color=yellow&label=⭐%20Stars)
![GitHub forks](https://img.shields.io/github/forks/TONUSER/musifyn?style=flat-square&logo=git&color=4A90D9&label=🍴%20Forks)
![GitHub issues](https://img.shields.io/github/issues/TONUSER/musifyn?style=flat-square&logo=github&color=red&label=🐛%20Issues)
![GitHub last commit](https://img.shields.io/github/last-commit/TONUSER/musifyn?style=flat-square&logo=github&label=📅%20Dernier%20commit)

</div>

<br/>

---

> [!WARNING]
> **🚧 VERSION DÉMO — EN DÉVELOPPEMENT ACTIF 🚧**
>
> Musifyn est actuellement en phase de démonstration. Le code source est disponible pour compiler l'application vous-même.
> Les binaires précompilés **(APK Android & EXE Windows)** seront publiés prochainement dans les [**Releases ↗**](../../releases).

---

<br/>

## 📸 Aperçu

<div align="center">

| 🔐 Connexion | 🏠 Accueil | 🎧 Lecteur |
|:---:|:---:|:---:|
| <img src="https://placehold.co/160x290/0D0A2E/FFFFFF?text=♪+Login%0A%0ADEMO&font=roboto" width="150" style="border-radius:12px"/> | <img src="https://placehold.co/160x290/0D0A2E/7B2FBE?text=♪+Accueil%0A%0ADEMO&font=roboto" width="150" style="border-radius:12px"/> | <img src="https://placehold.co/160x290/1A0A4E/4A90D9?text=♪+Player%0A%0ADEMO&font=roboto" width="150" style="border-radius:12px"/> |

| 🔍 Recherche | 📚 Bibliothèque | 🎶 Playlists |
|:---:|:---:|:---:|
| <img src="https://placehold.co/160x290/0D0A2E/FFFFFF?text=♪+Recherche%0A%0ADEMO&font=roboto" width="150" style="border-radius:12px"/> | <img src="https://placehold.co/160x290/0D0A2E/7B2FBE?text=♪+Biblio%0A%0ADEMO&font=roboto" width="150" style="border-radius:12px"/> | <img src="https://placehold.co/160x290/1A0A4E/4A90D9?text=♪+Playlists%0A%0ADEMO&font=roboto" width="150" style="border-radius:12px"/> |

*📸 Captures d'écran réelles à venir lors de la première release officielle*

</div>

<br/>

---

## 📦 Téléchargement

<div align="center">

| Plateforme | Statut | Lien |
|:---:|:---:|:---:|
| 📱 **Android (APK)** | [![soon](https://img.shields.io/badge/🔜-Bientôt%20disponible-7B2FBE?style=flat-square)](../../releases) | [Releases](../../releases) |
| 🖥️ **Windows (EXE)** | [![wip](https://img.shields.io/badge/🛠️-En%20développement-orange?style=flat-square)](../../releases) | — |
| 🍎 **iOS / macOS** | [![planned](https://img.shields.io/badge/📋-Prévu-555555?style=flat-square)](../../releases) | — |

</div>

> 💡 En attendant, compilez l'APK vous-même en 3 commandes — voir [**Compiler soi-même**](#-compiler-lapk-soi-même)

<br/>

---

## ✨ Fonctionnalités

<table>
<tr>
<td valign="top" width="50%">

### 🔐 Connexion & Session
- Saisie libre de l'IP, port, identifiant et mot de passe
- Session persistante — reconnexion automatique au lancement
- Déconnexion propre depuis la vue profil

### 🎧 Lecture audio
- Streaming direct depuis votre serveur Jellyfin
- Play / Pause / Suivant / Précédent
- Barre de progression interactive (seek)
- Répétition : **off** / **tout l'album** / **titre en cours**
- Lecture aléatoire (shuffle)

### 📻 Mini-player persistant
- Affiché en permanence pendant toute la navigation
- Contrôles rapides accessibles depuis n'importe quel écran

</td>
<td valign="top" width="50%">

### 🏠 Navigation style Spotify
- **Accueil** : albums récents & derniers ajouts
- **Recherche** : temps réel, titres · albums · artistes
- **Bibliothèque** : Artistes, Albums, Favoris
- Vue artiste avec discographie complète
- Vue album avec tracklist numérotée

### 🎶 Playlists locales
- Créer, renommer, supprimer une playlist
- Ajouter / retirer des titres
- Réorganiser par glisser-déposer
- Lancer la lecture depuis n'importe quelle position

### ❤️ Favoris
- Synchronisés directement avec votre serveur Jellyfin
- Accessible en un clic depuis la bibliothèque

</td>
</tr>
</table>

<br/>

---

## 🎨 Palette de couleurs

<div align="center">

| Rôle | Aperçu | Hex |
|:---:|:---:|:---:|
| Fond principal | ![bg](https://img.shields.io/badge/_%20%20%20%20%20%20%20%20%20%20%20%20-080812?style=flat-square) | `#080812` |
| Fond secondaire | ![bg2](https://img.shields.io/badge/_%20%20%20%20%20%20%20%20%20%20%20%20-0D0A2E?style=flat-square) | `#0D0A2E` |
| Accent violet | ![violet](https://img.shields.io/badge/_%20%20%20%20%20%20%20%20%20%20%20%20-7B2FBE?style=flat-square) | `#7B2FBE` |
| Accent bleu | ![bleu](https://img.shields.io/badge/_%20%20%20%20%20%20%20%20%20%20%20%20-4A90D9?style=flat-square) | `#4A90D9` |
| Surfaces | ![surf](https://img.shields.io/badge/_%20%20%20%20%20%20%20%20%20%20%20%20-12122A?style=flat-square) | `#12122A` |
| Texte secondaire | ![txt](https://img.shields.io/badge/_%20%20%20%20%20%20%20%20%20%20%20%20-8888AA?style=flat-square) | `#8888AA` |

</div>

<br/>

---

## 🚀 Compiler l'APK soi-même

### Prérequis

[![Flutter](https://img.shields.io/badge/Flutter%20SDK-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/docs/get-started/install)
[![Android SDK](https://img.shields.io/badge/Android%20SDK-API%2021%2B-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/studio)
[![Java](https://img.shields.io/badge/Java-11%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://adoptium.net)

### 3 commandes suffisent

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Compiler l'APK release
flutter build apk --release

# ✅ Votre APK est prêt ici :
#    build/app/outputs/flutter-apk/app-release.apk
```

> **Mode debug** — plus rapide, pas besoin de signature :
> ```bash
> flutter build apk --debug
> ```

### Installer sur le téléphone

```bash
# Via ADB (câble USB + débogage USB activé sur le téléphone)
adb install build/app/outputs/flutter-apk/app-release.apk
```

Ou copiez directement le `.apk` sur votre téléphone et ouvrez-le  
*(Paramètres → Sécurité → Activer "Sources inconnues")*

<br/>

---

## ☁️ Compiler via GitHub Actions

> Pas Flutter installé ? Pas de problème. Forkez le repo et créez ce fichier :

**`.github/workflows/build.yml`**

```yaml
name: 🎵 Build Musifyn APK

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build-android:
    name: 🔨 Build APK Android
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout du code
        uses: actions/checkout@v4

      - name: 🐦 Installation de Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'

      - name: 📦 Installation des dépendances
        run: flutter pub get

      - name: 🏗️ Compilation de l'APK
        run: flutter build apk --release

      - name: 📤 Upload de l'APK
        uses: actions/upload-artifact@v4
        with:
          name: musifyn-apk
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 30
```

L'APK compilé sera disponible dans l'onglet **Actions → votre workflow → Artifacts**.

<br/>

---

## 📁 Structure du projet

```
musifyn/
├── 📄 pubspec.yaml                         # Dépendances & config Flutter
│
├── lib/
│   ├── 📄 main.dart                        # Point d'entrée & thème global
│   │
│   ├── models/
│   │   └── 📄 media_item_model.dart        # Modèle de données unifié
│   │
│   ├── services/
│   │   ├── 📄 jellyfin_service.dart        # API Jellyfin (auth, stream, recherche…)
│   │   ├── 📄 player_service.dart          # Lecteur audio via just_audio
│   │   └── 📄 playlist_service.dart        # Playlists locales via SharedPreferences
│   │
│   ├── screens/
│   │   ├── 📄 login_screen.dart            # Écran de connexion
│   │   ├── 📄 home_screen.dart             # Navigation principale (BottomNavigationBar)
│   │   ├── 📄 home_tab.dart                # Onglet Accueil
│   │   ├── 📄 library_screen.dart          # Bibliothèque + ArtistScreen
│   │   ├── 📄 search_screen.dart           # Recherche temps réel
│   │   ├── 📄 playlists_screen.dart        # Playlists + PlaylistDetailScreen
│   │   ├── 📄 album_screen.dart            # Vue album avec tracklist
│   │   └── 📄 player_screen.dart           # Lecteur plein écran
│   │
│   └── widgets/
│       ├── 📄 mini_player.dart             # Barre de lecture persistante
│       ├── 📄 album_card.dart              # Carte album (grille & liste)
│       └── 📄 track_tile.dart              # Ligne de piste + menu contextuel
│
└── android/
    └── app/
        ├── 📄 build.gradle                 # Configuration build Android
        └── src/main/
            ├── 📄 AndroidManifest.xml      # Permissions & déclaration d'activité
            └── kotlin/…/MainActivity.kt
```

<br/>

---

## ⚙️ Prérequis côté serveur Jellyfin

```
✅  Jellyfin Server v10.8 ou supérieur
✅  Une bibliothèque musicale configurée dans Jellyfin
✅  Serveur accessible en HTTP (réseau local) ou HTTPS (accès distant)
```

**Format de l'URL à saisir dans Musifyn :**

| Type | Exemple |
|:---:|:---:|
| Réseau local | `http://192.168.1.42:8096` |
| Accès distant | `https://jellyfin.mondomaine.com` |

> ⚠️ Ne pas mettre de `/` à la fin de l'URL — Musifyn le gère automatiquement.

<br/>

---

## 🗺️ Roadmap

| Fonctionnalité | Statut |
|---|:---:|
| ✅ Authentification Jellyfin | **Terminé** |
| ✅ Streaming audio natif | **Terminé** |
| ✅ Navigation 4 onglets | **Terminé** |
| ✅ Lecteur plein écran style Spotify | **Terminé** |
| ✅ Mini-player persistant | **Terminé** |
| ✅ Playlists locales (CRUD + réorganisation) | **Terminé** |
| ✅ Favoris synchronisés avec Jellyfin | **Terminé** |
| 🔜 **Release APK publique** | **Bientôt** |
| 🛠️ **Version Windows (EXE)** | **En cours** |
| 📋 File d'attente éditable | Prévu |
| 📋 Paroles synchronisées (LRC) | Prévu |
| 📋 Widget Android (écran verrouillé) | Prévu |
| 📋 Égaliseur audio | Prévu |
| 📋 Thèmes de couleur personnalisables | Prévu |

<br/>

---

## 🤝 Contribuer

Les contributions sont les bienvenues !

```bash
# 1. Forkez le projet
# 2. Créez votre branche
git checkout -b feature/ma-fonctionnalite

# 3. Committez
git commit -m "feat: description de la modification"

# 4. Poussez
git push origin feature/ma-fonctionnalite

# 5. Ouvrez une Pull Request 🎉
```

Pour signaler un bug ou soumettre une idée → [![Issues](https://img.shields.io/badge/Ouvrir%20une%20Issue-red?style=flat-square&logo=github)](../../issues)

<br/>

---

## 📄 Licence

[![Licence MIT](https://img.shields.io/badge/Licence-MIT-7B2FBE?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE)

Ce projet est distribué sous licence **MIT** — voir [LICENSE](LICENSE) pour les détails.

<br/>

---

<div align="center">

Fait avec ♪ Flutter · Propulsé par [Jellyfin](https://jellyfin.org) · Inspiré de Spotify

*Musifyn n'est pas affilié à Jellyfin ni à Spotify.*

<br/>

[![GitHub](https://img.shields.io/badge/GitHub-TONUSER%2Fmusifyn-181717?style=flat-square&logo=github)](../../)
[![Issues](https://img.shields.io/badge/Issues-Signaler%20un%20bug-red?style=flat-square&logo=github)](../../issues)
[![Pull Requests](https://img.shields.io/badge/PR-Contribuer-7B2FBE?style=flat-square&logo=github)](../../pulls)

</div>

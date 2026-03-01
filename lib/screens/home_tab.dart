import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_service.dart';
import '../services/player_service.dart';
import '../services/playlist_service.dart';
import '../models/media_item_model.dart';
import '../widgets/frog_logo.dart';
import 'player_screen.dart';
import 'album_screen.dart';

class _GenreMix {
  final String name;
  final Color color;
  final IconData icon;
  final List<MediaItemModel> tracks;
  _GenreMix({required this.name, required this.color, required this.icon, required this.tracks});
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<MediaItemModel> _recentAlbums = [];
  List<MediaItemModel> _artists = [];
  List<MediaItemModel> _albums = [];
  List<MediaItemModel> _recentTracks = [];
  List<_GenreMix> _genreMixes = [];
  bool _loading = true;

  // Palette for genre mixes
  final List<Color> _mixColors = [
    const Color(0xFF8B5CF6),
    const Color(0xFF3B82F6),
    const Color(0xFF06B6D4),
    const Color(0xFF10B981),
    const Color(0xFFEF4444),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
    const Color(0xFFFF6B35),
  ];

  final List<IconData> _mixIcons = [
    Icons.mic, Icons.headphones, Icons.electric_bolt,
    Icons.waves, Icons.star, Icons.local_fire_department,
    Icons.music_note, Icons.equalizer,
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final jf = context.read<JellyfinService>();

    // Load all base data in parallel
    final albumsFuture = jf.getAlbums();
    final artistsFuture = jf.getArtists();
    final recentFuture = jf.getRecentlyPlayed();
    final genresFuture = jf.getGenres();

    final albums = await albumsFuture;
    final artists = await artistsFuture;
    final recent = await recentFuture;
    final genres = await genresFuture;

    // Build genre mixes from real genres (or fallback to random tracks)
    List<_GenreMix> mixes = [];
    if (genres.isNotEmpty) {
      final genreSubset = genres.take(4).toList();
      final List<List<MediaItemModel>> mixResults = await Future.wait(
        genreSubset.map((g) => jf.getTracksByGenre(g)),
      );
      for (int i = 0; i < genreSubset.length; i++) {
        if ((mixResults[i]).isNotEmpty) {
          mixes.add(_GenreMix(
            name: genreSubset[i],
            color: _mixColors[i % _mixColors.length],
            icon: _mixIcons[i % _mixIcons.length],
            tracks: mixResults[i],
          ));
        }
      }
    }
    // Fallback: 4 random mixes
    if (mixes.length < 4) {
      final needed = 4 - mixes.length;
      final List<List<MediaItemModel>> fallbackResults = await Future.wait(
        List.generate(needed, (_) => jf.getRandomTracks(limit: 15)),
      );
      final labels = ['Découvertes', 'Mix aléatoire', 'À écouter', 'Nouvelles pistes'];
      for (int i = 0; i < needed; i++) {
        mixes.add(_GenreMix(
          name: labels[i],
          color: _mixColors[(mixes.length + i) % _mixColors.length],
          icon: _mixIcons[(mixes.length + i) % _mixIcons.length],
          tracks: fallbackResults[i],
        ));
      }
    }

    if (mounted) {
      setState(() {
        _albums = albums;
        _recentAlbums = albums.take(8).toList();
        _artists = artists;
        _recentTracks = recent;
        _genreMixes = mixes;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final jf = context.read<JellyfinService>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(topPad, jf)),

        if (_loading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator(color: Color(0xFF1DB954))),
          )
        else ...[
          SliverToBoxAdapter(child: _buildRecentGrid()),
          SliverToBoxAdapter(child: _buildGenreCarousel()),
          SliverToBoxAdapter(child: _buildAllSections()),
          const SliverToBoxAdapter(child: SizedBox(height: 160)),
        ],
      ],
    );
  }

  // ── Compact header ──
  Widget _buildHeader(double topPad, JellyfinService jf) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: const Color(0xFF0A0A0A).withOpacity(0.6),
          padding: EdgeInsets.fromLTRB(16, topPad + 8, 16, 10),
          child: Row(
            children: [
              const FrogLogo(size: 30),
              const SizedBox(width: 10),
              const Text(
                'Musifyn',
                style: TextStyle(
                  fontFamily: 'SuperWonder',
                  color: Color(0xFF1DB954),
                  fontSize: 22,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                _greeting(),
                style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showProfile(context, jf),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1DB954).withOpacity(0.15),
                    border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF1DB954), size: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section : grille 4×2 récents ──
  Widget _buildRecentGrid() {
    final playlists = context.watch<PlaylistService>().playlists;
    final jf = context.read<JellyfinService>();
    final List<Widget> cells = [];

    for (final p in playlists.take(4)) {
      cells.add(_gridCell(
        label: p.name,
        color: p.color ?? const Color(0xFF1DB954),
        imagePath: p.imagePath,
        icon: Icons.queue_music,
        onTap: () {},
      ));
    }
    for (final album in _recentAlbums.take(8 - cells.length)) {
      cells.add(_gridCellNetwork(
        label: album.name,
        url: jf.getImageUrl(album.id, size: 100),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => AlbumScreen(album: album))),
      ));
    }
    if (cells.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Écoutés récemment'),
          const SizedBox(height: 10),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 4.5,
            children: cells.take(8).toList(),
          ),
        ],
      ),
    );
  }

  Widget _gridCell({
    required String label, required Color color,
    String? imagePath, required IconData icon, required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridCellNetwork({required String label, required String url, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
              child: Image.network(url,
                width: 44, height: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 44, color: const Color(0xFF1DB954).withOpacity(0.3),
                  child: const Icon(Icons.album, color: Color(0xFF1DB954), size: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section : carrousel mix genre ──
  Widget _buildGenreCarousel() {
    if (_genreMixes.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _sectionLabel('Mix pour toi'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _genreMixes.length,
              itemBuilder: (ctx, i) {
                final mix = _genreMixes[i];
                return GestureDetector(
                  onTap: () => _playMix(mix),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [mix.color.withOpacity(0.9), mix.color.withOpacity(0.35)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -12, bottom: -12,
                          child: Icon(mix.icon, size: 75,
                              color: Colors.white.withOpacity(0.12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(mix.icon, color: Colors.white, size: 28),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mix.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 2),
                                  Text('${mix.tracks.length} titres',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // play icon
                        Positioned(
                          bottom: 10, right: 10,
                          child: Container(
                            width: 30, height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _playMix(_GenreMix mix) {
    if (mix.tracks.isEmpty) return;
    final jf = context.read<JellyfinService>();
    final streamTracks = mix.tracks.map((t) => MediaItemModel(
      id: t.id, name: t.name, type: t.type,
      serverUrl: jf.getStreamUrl(t.id),
      artistName: t.artistName, albumName: t.albumName,
      albumId: t.albumId, durationMs: t.durationMs,
    )).toList();
    context.read<PlayerService>().playTrack(
        streamTracks.first, queue: streamTracks, index: 0);
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }

  // ── 12 sections ──
  Widget _buildAllSections() {
    final jf = context.read<JellyfinService>();

    // Build varied sections from real data
    final sections = <Widget>[];

    if (_albums.isNotEmpty) {
      sections.add(_horizSection('Nouveaux albums',
          _albums.take(15).toList(), (a) => _albumCard(a, jf)));
    }
    if (_artists.isNotEmpty) {
      sections.add(_horizSection('Artistes',
          _artists.take(15).toList(), (a) => _artistCard(a, jf), isArtist: true));
    }
    if (_recentTracks.isNotEmpty) {
      sections.add(_horizSection('Ajoutés récemment',
          _recentTracks.take(15).toList(), (t) => _trackCard(t, jf)));
    }
    if (_albums.length > 5) {
      sections.add(_horizSection('Albums par date',
          (_albums..sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0)))
              .take(15).toList(),
          (a) => _albumCard(a, jf)));
    }
    if (_artists.length > 4) {
      sections.add(_horizSection('À découvrir',
          _artists.reversed.take(15).toList(),
          (a) => _artistCard(a, jf), isArtist: true));
    }
    if (_albums.length > 8) {
      sections.add(_horizSection('Albums populaires',
          _albums.skip(3).take(15).toList(), (a) => _albumCard(a, jf)));
    }
    if (_recentTracks.length > 5) {
      sections.add(_horizSection('Vos favoris récents',
          _recentTracks.skip(2).take(15).toList(), (t) => _trackCard(t, jf)));
    }
    if (_artists.length > 8) {
      sections.add(_horizSection('Artistes similaires',
          _artists.skip(4).take(15).toList(),
          (a) => _artistCard(a, jf), isArtist: true));
    }
    if (_albums.length > 10) {
      sections.add(_horizSection('Compilations',
          _albums.skip(6).take(15).toList(), (a) => _albumCard(a, jf)));
    }
    if (_albums.length > 12) {
      sections.add(_horizSection('Singles & EPs',
          _albums.skip(9).take(15).toList(), (a) => _albumCard(a, jf)));
    }
    if (_artists.length > 10) {
      sections.add(_horizSection('Les plus joués',
          _artists.skip(6).take(15).toList(),
          (a) => _artistCard(a, jf), isArtist: true));
    }
    if (_albums.length > 15) {
      sections.add(_horizSection('Nouveautés',
          _albums.skip(12).take(15).toList(), (a) => _albumCard(a, jf)));
    }

    return Column(children: sections);
  }

  Widget _horizSection(
    String title,
    List<MediaItemModel> items,
    Widget Function(MediaItemModel) builder, {
    bool isArtist = false,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    final cardH = isArtist ? 155.0 : 175.0;
    final cardW = isArtist ? 110.0 : 135.0;

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionLabel(title),
                Text('Tout voir',
                    style: TextStyle(
                        color: const Color(0xFF1DB954).withOpacity(0.8),
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: cardH,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (ctx, i) =>
                  SizedBox(width: cardW, child: builder(items[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _albumCard(MediaItemModel album, JellyfinService jf) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => AlbumScreen(album: album))),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                jf.getImageUrl(album.id, size: 300),
                width: 123, height: 123, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 123, height: 123,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DB954).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.album, color: Color(0xFF1DB954), size: 40),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(album.name,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            if (album.artistName != null)
              Text(album.artistName!,
                  style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _artistCard(MediaItemModel artist, JellyfinService jf) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            ClipOval(
              child: Image.network(
                jf.getImageUrl(artist.id, size: 200),
                width: 90, height: 90, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90, height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFF1A2A1F),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF1DB954), size: 36),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(artist.name,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
            Text('Artiste',
                style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _trackCard(MediaItemModel track, JellyfinService jf) {
    return GestureDetector(
      onTap: () => _playTrack(track),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: track.albumId != null
                      ? Image.network(
                          jf.getImageUrl(track.albumId!, size: 300),
                          width: 123, height: 123, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _trackPlaceholder(),
                        )
                      : _trackPlaceholder(),
                ),
                Positioned(
                  bottom: 6, right: 6,
                  child: Container(
                    width: 28, height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF1DB954),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(track.name,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            if (track.artistName != null)
              Text(track.artistName!,
                  style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _trackPlaceholder() {
    return Container(
      width: 123, height: 123,
      decoration: BoxDecoration(
        color: const Color(0xFF1DB954).withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFF1DB954), size: 40),
    );
  }

  void _playTrack(MediaItemModel track) {
    final jf = context.read<JellyfinService>();
    final s = MediaItemModel(
      id: track.id, name: track.name, type: track.type,
      serverUrl: jf.getStreamUrl(track.id),
      artistName: track.artistName, albumName: track.albumName,
      albumId: track.albumId, durationMs: track.durationMs,
    );
    context.read<PlayerService>().playTrack(s, queue: [s]);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800));

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour 🌅';
    if (h < 18) return 'Bon après-midi ☀️';
    return 'Bonsoir 🌙';
  }

  void _showProfile(BuildContext context, JellyfinService jf) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FrogLogo(size: 56),
            const SizedBox(height: 12),
            Text(jf.username ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(jf.serverUrl ?? '',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () { Navigator.pop(context); jf.logout(); },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

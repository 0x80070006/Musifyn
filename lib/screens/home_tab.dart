import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_service.dart';
import '../services/player_service.dart';
import '../models/media_item_model.dart';
import '../widgets/album_card.dart';
import '../widgets/track_tile.dart';
import 'player_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<MediaItemModel> _recentAlbums = [];
  List<MediaItemModel> _recentTracks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final jellyfin = context.read<JellyfinService>();
    final albums = await jellyfin.getAlbums();
    final tracks = await jellyfin.getRecentlyPlayed();
    if (mounted) {
      setState(() {
        _recentAlbums = albums.take(10).toList();
        _recentTracks = tracks.take(10).toList();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final jellyfin = context.watch<JellyfinService>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Musifyn',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A0533), Color(0xFF0D0D2B)],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () => _showProfile(context, jellyfin),
              ),
            ],
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF7B2FBE))),
            )
          else
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _sectionTitle('Albums récents'),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _recentAlbums.length,
                      itemBuilder: (ctx, i) => AlbumCard(album: _recentAlbums[i]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Récemment ajoutés'),
                  ...List.generate(_recentTracks.length, (i) => TrackTile(
                    track: _recentTracks[i],
                    onTap: () => _playTrack(_recentTracks[i]),
                  )),
                  const SizedBox(height: 100),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _playTrack(MediaItemModel track) {
    final jellyfin = context.read<JellyfinService>();
    final streamUrl = jellyfin.getStreamUrl(track.id);
    final streamTrack = MediaItemModel(
      id: track.id,
      name: track.name,
      type: track.type,
      serverUrl: streamUrl,
      artistName: track.artistName,
      albumName: track.albumName,
      albumId: track.albumId,
      durationMs: track.durationMs,
    );
    context.read<PlayerService>().playTrack(streamTrack, queue: [streamTrack]);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }

  void _showProfile(BuildContext context, JellyfinService jellyfin) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF12122A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle, size: 60, color: Color(0xFF7B2FBE)),
            const SizedBox(height: 12),
            Text(jellyfin.username ?? '', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(jellyfin.serverUrl ?? '', style: const TextStyle(color: Color(0xFF8888AA), fontSize: 13)),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                jellyfin.logout();
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

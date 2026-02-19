import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_service.dart';
import '../services/player_service.dart';
import '../models/media_item_model.dart';
import '../widgets/track_tile.dart';
import 'player_screen.dart';

class AlbumScreen extends StatefulWidget {
  final MediaItemModel album;
  const AlbumScreen({super.key, required this.album});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<MediaItemModel> _tracks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tracks = await context.read<JellyfinService>().getAlbumTracks(widget.album.id);
    if (mounted) setState(() { _tracks = tracks; _loading = false; });
  }

  void _playAll() {
    final jellyfin = context.read<JellyfinService>();
    final streamTracks = _tracks.map((t) => MediaItemModel(
      id: t.id, name: t.name, type: t.type,
      serverUrl: jellyfin.getStreamUrl(t.id),
      artistName: t.artistName, albumName: t.albumName,
      albumId: t.albumId, durationMs: t.durationMs,
    )).toList();
    context.read<PlayerService>().playTrack(streamTracks.first, queue: streamTracks, index: 0);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final jellyfin = context.read<JellyfinService>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    jellyfin.getImageUrl(widget.album.id, size: 600),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)],
                        ),
                      ),
                      child: const Icon(Icons.album, size: 80, color: Colors.white54),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF080812)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.album.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        if (widget.album.artistName != null)
                          Text(widget.album.artistName!, style: const TextStyle(color: Color(0xFF8888AA))),
                        if (widget.album.year != null)
                          Text('${widget.album.year}', style: const TextStyle(color: Color(0xFF8888AA), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)]),
                    ),
                    child: IconButton(
                      onPressed: _playAll,
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF7B2FBE))),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final track = _tracks[i];
                  return TrackTile(
                    track: track,
                    showNumber: true,
                    onTap: () {
                      final streamTracks = _tracks.map((t) => MediaItemModel(
                        id: t.id, name: t.name, type: t.type,
                        serverUrl: jellyfin.getStreamUrl(t.id),
                        artistName: t.artistName, albumName: t.albumName,
                        albumId: t.albumId, durationMs: t.durationMs,
                      )).toList();
                      context.read<PlayerService>().playTrack(
                        streamTracks[i], queue: streamTracks, index: i,
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                    },
                  );
                },
                childCount: _tracks.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

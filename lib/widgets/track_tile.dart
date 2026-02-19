import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/media_item_model.dart';
import '../services/jellyfin_service.dart';
import '../services/playlist_service.dart';

class TrackTile extends StatelessWidget {
  final MediaItemModel track;
  final VoidCallback onTap;
  final bool showNumber;

  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
    this.showNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    final jellyfin = context.read<JellyfinService>();

    return ListTile(
      onTap: onTap,
      leading: showNumber
          ? SizedBox(
              width: 32,
              child: Text(
                '${track.trackNumber ?? ""}',
                style: const TextStyle(color: Color(0xFF8888AA), fontSize: 15),
                textAlign: TextAlign.center,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: track.albumId != null
                  ? Image.network(
                      jellyfin.getImageUrl(track.albumId!, size: 80),
                      width: 44, height: 44, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
      title: Text(
        track.name,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${track.artistName ?? ""}${track.albumName != null ? " · ${track.albumName}" : ""}',
        style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (track.durationMs != null)
            Text(track.durationFormatted, style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
          PopupMenuButton<String>(
            color: const Color(0xFF12122A),
            icon: const Icon(Icons.more_vert, color: Color(0xFF555577), size: 20),
            onSelected: (action) {
              if (action == 'add_playlist') _addToPlaylist(context, track);
              if (action == 'queue') {
                // Would need player service access
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'add_playlist',
                child: Row(children: [
                  Icon(Icons.playlist_add, color: Color(0xFF7B2FBE), size: 18),
                  SizedBox(width: 8),
                  Text('Ajouter à une playlist', style: TextStyle(color: Colors.white)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 44, height: 44,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)]),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54, size: 20),
    );
  }

  void _addToPlaylist(BuildContext context, MediaItemModel track) {
    final playlists = context.read<PlaylistService>().playlists;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF12122A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Ajouter à une playlist', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          if (playlists.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Aucune playlist disponible', style: TextStyle(color: Color(0xFF8888AA))),
            )
          else
            ...playlists.map((p) => ListTile(
              leading: const Icon(Icons.queue_music, color: Color(0xFF7B2FBE)),
              title: Text(p.name, style: const TextStyle(color: Colors.white)),
              onTap: () {
                context.read<PlaylistService>().addTrack(p.id, track);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ajouté à ${p.name}'), backgroundColor: const Color(0xFF7B2FBE)),
                );
              },
            )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

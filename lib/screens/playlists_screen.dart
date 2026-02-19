import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/playlist_service.dart';
import '../services/player_service.dart';
import '../models/media_item_model.dart';
import '../widgets/track_tile.dart';
import 'player_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Playlists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF7B2FBE)),
            onPressed: () => _createPlaylist(context),
          ),
        ],
      ),
      body: Consumer<PlaylistService>(
        builder: (context, service, _) {
          if (service.playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.queue_music, size: 80, color: Color(0xFF2A2A4A)),
                  const SizedBox(height: 16),
                  const Text('Aucune playlist', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('Créez votre première playlist', style: TextStyle(color: Color(0xFF8888AA))),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _createPlaylist(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer une playlist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2FBE),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: service.playlists.length,
            itemBuilder: (ctx, i) {
              final playlist = service.playlists[i];
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)],
                    ),
                  ),
                  child: const Icon(Icons.queue_music, color: Colors.white),
                ),
                title: Text(playlist.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text('${playlist.tracks.length} titre${playlist.tracks.length != 1 ? "s" : ""}',
                    style: const TextStyle(color: Color(0xFF8888AA))),
                trailing: PopupMenuButton<String>(
                  color: const Color(0xFF12122A),
                  icon: const Icon(Icons.more_vert, color: Color(0xFF8888AA)),
                  onSelected: (action) {
                    if (action == 'rename') _renamePlaylist(context, service, playlist.id, playlist.name);
                    if (action == 'delete') service.delete(playlist.id);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'rename', child: Text('Renommer', style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlistId: playlist.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _createPlaylist(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF12122A),
        title: const Text('Nouvelle playlist', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nom de la playlist',
            hintStyle: TextStyle(color: Color(0xFF555577)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF7B2FBE))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF7B2FBE))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<PlaylistService>().create(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Créer', style: TextStyle(color: Color(0xFF7B2FBE))),
          ),
        ],
      ),
    );
  }

  void _renamePlaylist(BuildContext context, PlaylistService service, String id, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF12122A),
        title: const Text('Renommer', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF7B2FBE))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF7B2FBE))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              service.rename(id, controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFF7B2FBE))),
          ),
        ],
      ),
    );
  }
}

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;
  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistService>(
      builder: (context, service, _) {
        final playlist = service.playlists.firstWhere((p) => p.id == playlistId, orElse: () => LocalPlaylist(id: '', name: '', tracks: [], createdAt: DateTime.now()));

        return Scaffold(
          appBar: AppBar(
            title: Text(playlist.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          body: playlist.tracks.isEmpty
              ? const Center(child: Text('Playlist vide', style: TextStyle(color: Color(0xFF8888AA))))
              : ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: playlist.tracks.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    service.reorderTrack(playlistId, oldIndex, newIndex);
                  },
                  itemBuilder: (ctx, i) {
                    final track = playlist.tracks[i];
                    return Dismissible(
                      key: Key('${track.id}_$i'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red.withOpacity(0.3),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      onDismissed: (_) => service.removeTrack(playlistId, track.id),
                      child: TrackTile(
                        track: track,
                        onTap: () => _playFrom(context, playlist.tracks, i),
                      ),
                    );
                  },
                ),
          floatingActionButton: playlist.tracks.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () => _playFrom(context, playlist.tracks, 0),
                  backgroundColor: const Color(0xFF7B2FBE),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Lecture'),
                )
              : null,
        );
      },
    );
  }

  void _playFrom(BuildContext context, List<MediaItemModel> tracks, int index) {
    final player = context.read<PlayerService>();
    player.playTrack(tracks[index], queue: tracks, index: index);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }
}

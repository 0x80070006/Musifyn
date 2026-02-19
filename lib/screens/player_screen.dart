import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../services/player_service.dart';
import '../services/jellyfin_service.dart';
import '../services/playlist_service.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerService>();
    final track = player.currentTrack;
    final jellyfin = context.read<JellyfinService>();

    if (track == null) {
      return const Scaffold(body: Center(child: Text('Aucune piste', style: TextStyle(color: Colors.white))));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0533), Color(0xFF0D0D2B), Color(0xFF080812)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text('En lecture', style: TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.playlist_add, color: Colors.white),
                      onPressed: () => _addToPlaylist(context, track.id),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Album art
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B2FBE).withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: track.albumId != null
                      ? Image.network(
                          jellyfin.getImageUrl(track.albumId!, size: 500),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderArt(),
                        )
                      : _placeholderArt(),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.name,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track.artistName ?? 'Artiste inconnu',
                            style: const TextStyle(color: Color(0xFF8888AA), fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    FavoriteButton(itemId: track.id),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (ctx, posSnap) {
                    return StreamBuilder<Duration?>(
                      stream: player.durationStream,
                      builder: (ctx, durSnap) {
                        final position = posSnap.data ?? Duration.zero;
                        final duration = durSnap.data ?? Duration.zero;
                        final progress = duration.inMilliseconds > 0
                            ? position.inMilliseconds / duration.inMilliseconds
                            : 0.0;
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(ctx).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                activeTrackColor: const Color(0xFF7B2FBE),
                                inactiveTrackColor: const Color(0xFF2A2A4A),
                                thumbColor: Colors.white,
                                overlayColor: const Color(0xFF7B2FBE).withOpacity(0.2),
                              ),
                              child: Slider(
                                value: progress.clamp(0.0, 1.0),
                                onChanged: (v) {
                                  final newPos = Duration(milliseconds: (v * duration.inMilliseconds).round());
                                  player.seek(newPos);
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(position), style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                                Text(_formatDuration(duration), style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: player.shuffle ? const Color(0xFF7B2FBE) : const Color(0xFF8888AA),
                      ),
                      onPressed: player.toggleShuffle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                      onPressed: player.skipPrevious,
                    ),
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)]),
                      ),
                      child: StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder: (ctx, snap) {
                          final isPlaying = snap.data?.playing ?? false;
                          final loading = snap.data?.processingState == ProcessingState.loading ||
                              snap.data?.processingState == ProcessingState.buffering;
                          return IconButton(
                            onPressed: player.playPause,
                            icon: loading
                                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                : Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 36),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                      onPressed: player.skipNext,
                    ),
                    IconButton(
                      icon: Icon(
                        player.loopMode == LoopMode.one ? Icons.repeat_one :
                        player.loopMode == LoopMode.all ? Icons.repeat : Icons.repeat,
                        color: player.loopMode != LoopMode.off ? const Color(0xFF7B2FBE) : const Color(0xFF8888AA),
                      ),
                      onPressed: player.cycleLoopMode,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderArt() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)],
        ),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54, size: 80),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _addToPlaylist(BuildContext context, String itemId) {
    final playlists = context.read<PlaylistService>().playlists;
    final jellyfin = context.read<JellyfinService>();
    final playerService = context.read<PlayerService>();
    final track = playerService.currentTrack;

    if (track == null) return;

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
              child: Text('Aucune playlist. Créez-en une dans l\'onglet Playlists.', style: TextStyle(color: Color(0xFF8888AA))),
            )
          else
            ...playlists.map((p) => ListTile(
              leading: const Icon(Icons.queue_music, color: Color(0xFF7B2FBE)),
              title: Text(p.name, style: const TextStyle(color: Colors.white)),
              onTap: () {
                context.read<PlaylistService>().addTrack(p.id, track);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ajouté à ${p.name}'),
                    backgroundColor: const Color(0xFF7B2FBE),
                  ),
                );
              },
            )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final String itemId;
  const FavoriteButton({super.key, required this.itemId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? const Color(0xFF7B2FBE) : const Color(0xFF8888AA),
      ),
      onPressed: () async {
        await context.read<JellyfinService>().toggleFavorite(widget.itemId, _isFavorite);
        setState(() => _isFavorite = !_isFavorite);
      },
    );
  }
}

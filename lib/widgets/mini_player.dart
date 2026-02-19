import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../services/player_service.dart';
import '../services/jellyfin_service.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerService>();
    final track = player.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final jellyfin = context.read<JellyfinService>();

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen())),
      child: Container(
        height: 72,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A0D3A), Color(0xFF0D1A3A)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7B2FBE).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B2FBE).withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: track.albumId != null
                  ? Image.network(
                      jellyfin.getImageUrl(track.albumId!, size: 100),
                      width: 48, height: 48, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    track.artistName ?? '',
                    style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: player.skipPrevious,
              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 22),
            ),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (ctx, snap) {
                final isPlaying = snap.data?.playing ?? false;
                return IconButton(
                  onPressed: player.playPause,
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: const Color(0xFF7B2FBE),
                    size: 36,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: player.skipNext,
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)]),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54, size: 24),
    );
  }
}

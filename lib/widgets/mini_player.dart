import 'dart:ui';
import 'dart:io';
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
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const PlayerScreen())),
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withOpacity(0.85),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF1DB954).withOpacity(0.2),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  // Art
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: track.albumId != null
                        ? Image.network(
                            jellyfin.getImageUrl(track.albumId!, size: 100),
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          track.artistName ?? '',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Controls
                  StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (ctx, snap) {
                      final playing = snap.data?.playing ?? false;
                      return Row(
                        children: [
                          IconButton(
                            onPressed: player.skipPrevious,
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 36, minHeight: 36),
                          ),
                          GestureDetector(
                            onTap: player.playPause,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1DB954),
                              ),
                              child: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: player.skipNext,
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 36, minHeight: 36),
                          ),
                          const SizedBox(width: 4),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: Color(0xFF1A2A1F),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: const Icon(Icons.music_note,
          color: Color(0xFF1DB954), size: 22),
    );
  }
}

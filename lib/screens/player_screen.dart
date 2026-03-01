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
      return const Scaffold(
          body:
              Center(child: Text('Aucune piste', style: TextStyle(color: Colors.white))));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D2117), Color(0xFF0A1A0F), Color(0xFF080808)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text('EN LECTURE',
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5)),
                          SizedBox(height: 2),
                          Text('File d\'attente',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.playlist_add,
                          color: Colors.white, size: 24),
                      onPressed: () =>
                          _addToPlaylist(context, track),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Album art
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1DB954).withOpacity(0.3),
                          blurRadius: 50,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: track.albumId != null
                          ? Image.network(
                              jellyfin.getImageUrl(track.albumId!,
                                  size: 600),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _artPlaceholder(),
                            )
                          : _artPlaceholder(),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Title + heart
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                track.artistName ?? 'Artiste inconnu',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _FavoriteBtn(itemId: track.id),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Progress
                    _ProgressBar(player: player),

                    const SizedBox(height: 20),

                    // Main controls
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        // Shuffle
                        _ControlIcon(
                          icon: Icons.shuffle,
                          active: player.shuffle,
                          onTap: player.toggleShuffle,
                          size: 22,
                        ),
                        // Prev
                        IconButton(
                          onPressed: player.skipPrevious,
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white, size: 36),
                        ),
                        // Play/Pause
                        StreamBuilder<PlayerState>(
                          stream: player.playerStateStream,
                          builder: (ctx, snap) {
                            final playing =
                                snap.data?.playing ?? false;
                            final loading = snap.data?.processingState ==
                                    ProcessingState.loading ||
                                snap.data?.processingState ==
                                    ProcessingState.buffering;
                            return GestureDetector(
                              onTap: player.playPause,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: loading
                                    ? const Padding(
                                        padding: EdgeInsets.all(16),
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Icon(
                                        playing
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black,
                                        size: 36,
                                      ),
                              ),
                            );
                          },
                        ),
                        // Next
                        IconButton(
                          onPressed: player.skipNext,
                          icon: const Icon(Icons.skip_next,
                              color: Colors.white, size: 36),
                        ),
                        // Loop
                        _ControlIcon(
                          icon: player.loopMode == LoopMode.one
                              ? Icons.repeat_one
                              : Icons.repeat,
                          active: player.loopMode != LoopMode.off,
                          onTap: player.cycleLoopMode,
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _artPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1DB954), Color(0xFF148A3C)],
        ),
      ),
      child: const Icon(Icons.music_note,
          color: Colors.white24, size: 80),
    );
  }

  void _addToPlaylist(BuildContext context, track) {
    final playlists =
        context.read<PlaylistService>().playlists;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181818),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Ajouter à une playlist',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
          ),
          if (playlists.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Créez d\'abord une playlist',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4))),
            )
          else
            ...playlists.map((p) => ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: p.color ?? const Color(0xFF1DB954),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.queue_music,
                        color: Colors.white, size: 22),
                  ),
                  title: Text(p.name,
                      style:
                          const TextStyle(color: Colors.white)),
                  onTap: () {
                    context
                        .read<PlaylistService>()
                        .addTrack(p.id, track);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ajouté à ${p.name}'),
                        backgroundColor: const Color(0xFF1DB954),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final PlayerService player;
  const _ProgressBar({required this.player});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (ctx, posSnap) {
        return StreamBuilder<Duration?>(
          stream: player.durationStream,
          builder: (ctx, durSnap) {
            final pos = posSnap.data ?? Duration.zero;
            final dur = durSnap.data ?? Duration.zero;
            final progress = dur.inMilliseconds > 0
                ? (pos.inMilliseconds / dur.inMilliseconds)
                    .clamp(0.0, 1.0)
                : 0.0;
            return Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(ctx).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                  ),
                  child: Slider(
                    value: progress,
                    onChanged: (v) => player.seek(Duration(
                        milliseconds:
                            (v * dur.inMilliseconds).round())),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_fmt(pos),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11)),
                    Text(_fmt(dur),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11)),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _ControlIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final double size;

  const _ControlIcon({
    required this.icon,
    required this.active,
    required this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon,
              color: active
                  ? const Color(0xFF1DB954)
                  : Colors.white.withOpacity(0.6),
              size: size),
        ),
        if (active)
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1DB954),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FavoriteBtn extends StatefulWidget {
  final String itemId;
  const _FavoriteBtn({required this.itemId});

  @override
  State<_FavoriteBtn> createState() => _FavoriteBtnState();
}

class _FavoriteBtnState extends State<_FavoriteBtn> {
  bool _fav = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _fav ? Icons.favorite : Icons.favorite_border,
        color: _fav ? const Color(0xFF1DB954) : Colors.white.withOpacity(0.6),
        size: 26,
      ),
      onPressed: () async {
        await context.read<JellyfinService>().toggleFavorite(widget.itemId, _fav);
        setState(() => _fav = !_fav);
      },
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/playlist_service.dart';
import '../services/player_service.dart';
import '../models/media_item_model.dart';
import '../widgets/track_tile.dart';
import 'player_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Consumer<PlaylistService>(
      builder: (context, service, _) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: topPad + 16),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mes Playlists',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900)),
                    GestureDetector(
                      onTap: () => _showCreateDialog(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1DB954),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.black, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (service.playlists.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.queue_music,
                          size: 72,
                          color: Colors.white.withOpacity(0.15)),
                      const SizedBox(height: 16),
                      Text('Aucune playlist',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 16)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _showCreateDialog(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1DB954),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text('Créer une playlist',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final p = service.playlists[i];
                    return _PlaylistTile(
                      playlist: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PlaylistDetailScreen(playlistId: p.id)),
                      ),
                      onEdit: () => _showEditPanel(context, p),
                    );
                  },
                  childCount: service.playlists.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 160)),
          ],
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nouvelle playlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nom de la playlist',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1DB954))),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1DB954), width: 2)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler',
                  style:
                      TextStyle(color: Colors.white.withOpacity(0.5)))),
          TextButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                context.read<PlaylistService>().create(ctrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Créer',
                style: TextStyle(
                    color: Color(0xFF1DB954), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showEditPanel(BuildContext context, LocalPlaylist playlist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditPlaylistPanel(playlist: playlist),
    );
  }
}

// ─── Tile with pencil icon ───
class _PlaylistTile extends StatelessWidget {
  final LocalPlaylist playlist;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _PlaylistTile({
    required this.playlist,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _PlaylistAvatar(playlist: playlist, size: 52),
      title: Text(playlist.name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14)),
      subtitle: Text(
        '${playlist.tracks.length} titre${playlist.tracks.length != 1 ? "s" : ""}',
        style:
            TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
      ),
      trailing: GestureDetector(
        onTap: onEdit,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
          ),
          child: Icon(Icons.edit_outlined,
              color: Colors.white.withOpacity(0.6), size: 16),
        ),
      ),
    );
  }
}

// ─── Playlist avatar (image or colored icon) ───
class _PlaylistAvatar extends StatelessWidget {
  final LocalPlaylist playlist;
  final double size;

  const _PlaylistAvatar({required this.playlist, this.size = 52});

  @override
  Widget build(BuildContext context) {
    final color = playlist.color ?? const Color(0xFF1DB954);

    if (playlist.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(playlist.imagePath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _coloredIcon(color),
        ),
      );
    }
    return _coloredIcon(color);
  }

  Widget _coloredIcon(Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.queue_music,
          color: Colors.white.withOpacity(0.9), size: size * 0.45),
    );
  }
}

// ─── Edit panel ───
class _EditPlaylistPanel extends StatefulWidget {
  final LocalPlaylist playlist;
  const _EditPlaylistPanel({required this.playlist});

  @override
  State<_EditPlaylistPanel> createState() => _EditPlaylistPanelState();
}

class _EditPlaylistPanelState extends State<_EditPlaylistPanel> {
  late TextEditingController _nameCtrl;
  Color? _selectedColor;
  String? _imagePath;

  final List<Color> _colors = [
    const Color(0xFF1DB954), // vert
    const Color(0xFF3B82F6), // bleu
    const Color(0xFFEF4444), // rouge
    const Color(0xFFF59E0B), // jaune
    const Color(0xFF8B5CF6), // violet
    const Color(0xFF000000), // noir
    const Color(0xFFEC4899), // rose
    const Color(0xFF06B6D4), // cyan
    const Color(0xFFFF6B35), // orange
    const Color(0xFFFFFFFF), // blanc
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.playlist.name);
    _selectedColor = widget.playlist.color;
    _imagePath = widget.playlist.imagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null && mounted) {
      setState(() => _imagePath = picked.path);
    }
  }

  Future<void> _save() async {
    await context.read<PlaylistService>().update(
          widget.playlist.id,
          name: _nameCtrl.text.trim().isNotEmpty
              ? _nameCtrl.text.trim()
              : null,
          color: _selectedColor,
          imagePath: _imagePath,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    Navigator.pop(context); // close edit panel first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer la playlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${widget.playlist.name}" ?',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Annuler',
                  style:
                      TextStyle(color: Colors.white.withOpacity(0.5)))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<PlaylistService>().delete(widget.playlist.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPad + 20),
      decoration: const BoxDecoration(
        color: Color(0xFF181818),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Preview
          Center(
            child: _EditablePlaylistAvatar(
              imagePath: _imagePath,
              color: _selectedColor,
              onTap: _pickImage,
            ),
          ),
          const SizedBox(height: 20),

          // Name field
          const Text('Nom',
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.07),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xFF1DB954), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),

          // Color picker
          const Text('Couleur',
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _colors.map((c) {
              final selected = _selectedColor == c;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedColor = c;
                  _imagePath = null; // clear image if color chosen
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.1),
                      width: selected ? 2.5 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                                color: c.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2)
                          ]
                        : null,
                  ),
                  child: selected
                      ? Icon(Icons.check,
                          size: 18,
                          color: c == Colors.white
                              ? Colors.black
                              : Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Image button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_outlined,
                  color: Color(0xFF1DB954), size: 18),
              label: Text(
                _imagePath != null
                    ? 'Changer l\'image'
                    : 'Choisir une image',
                style: const TextStyle(color: Color(0xFF1DB954)),
              ),
              style: OutlinedButton.styleFrom(
                side:
                    const BorderSide(color: Color(0xFF1DB954), width: 1.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Enregistrer',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 15)),
            ),
          ),

          const SizedBox(height: 12),

          // Delete button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text('Supprimer la playlist',
                  style: TextStyle(color: Colors.red)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditablePlaylistAvatar extends StatelessWidget {
  final String? imagePath;
  final Color? color;
  final VoidCallback onTap;

  const _EditablePlaylistAvatar({
    this.imagePath,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? const Color(0xFF1DB954);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagePath != null
                ? Image.file(File(imagePath!),
                    width: 100, height: 100, fit: BoxFit.cover)
                : Container(
                    width: 100,
                    height: 100,
                    color: bg,
                    child: const Icon(Icons.queue_music,
                        color: Colors.white, size: 46),
                  ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt,
                  color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Playlist Detail ───
class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;
  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistService>(
      builder: (context, service, _) {
        final playlist = service.playlists.firstWhere(
          (p) => p.id == playlistId,
          orElse: () => LocalPlaylist(
              id: '',
              name: '',
              tracks: [],
              createdAt: DateTime.now()),
        );

        final color = playlist.color ?? const Color(0xFF1DB954);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: color.withOpacity(0.8),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(playlist.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800)),
                  background: playlist.imagePath != null
                      ? Image.file(File(playlist.imagePath!),
                          fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [color, color.withOpacity(0.3)],
                            ),
                          ),
                          child: Icon(Icons.queue_music,
                              size: 80,
                              color: Colors.white.withOpacity(0.3)),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${playlist.tracks.length} titre${playlist.tracks.length != 1 ? "s" : ""}',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13),
                      ),
                      const Spacer(),
                      if (playlist.tracks.isNotEmpty)
                        GestureDetector(
                          onTap: () => _playAll(context, playlist.tracks),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.black, size: 30),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (playlist.tracks.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text('Playlist vide',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4))),
                  ),
                )
              else
                SliverReorderableList(
                  itemCount: playlist.tracks.length,
                  onReorder: (o, n) {
                    if (n > o) n--;
                    service.reorder(playlistId, o, n);
                  },
                  itemBuilder: (ctx, i) {
                    final track = playlist.tracks[i];
                    return ReorderableDelayedDragStartListener(
                      key: Key('${track.id}_$i'),
                      index: i,
                      child: Dismissible(
                        key: Key('d_${track.id}_$i'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red.withOpacity(0.3),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.red),
                        ),
                        onDismissed: (_) =>
                            service.removeTrack(playlistId, track.id),
                        child: TrackTile(
                          track: track,
                          onTap: () => _playFrom(context,
                              playlist.tracks, i),
                        ),
                      ),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 160)),
            ],
          ),
        );
      },
    );
  }

  void _playAll(BuildContext context, List<MediaItemModel> tracks) =>
      _playFrom(context, tracks, 0);

  void _playFrom(
      BuildContext context, List<MediaItemModel> tracks, int index) {
    context
        .read<PlayerService>()
        .playTrack(tracks[index], queue: tracks, index: index);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }
}

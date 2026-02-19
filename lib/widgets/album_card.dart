import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/media_item_model.dart';
import '../services/jellyfin_service.dart';
import '../screens/album_screen.dart';

class AlbumCard extends StatelessWidget {
  final MediaItemModel album;
  final bool large;
  const AlbumCard({super.key, required this.album, this.large = false});

  @override
  Widget build(BuildContext context) {
    final jellyfin = context.read<JellyfinService>();
    final size = large ? 150.0 : 130.0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AlbumScreen(album: album)),
      ),
      child: Container(
        width: size,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                jellyfin.getImageUrl(album.id, size: 300),
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)]),
                  ),
                  child: const Icon(Icons.album, color: Colors.white54, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              album.name,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (album.artistName != null)
              Text(
                album.artistName!,
                style: const TextStyle(color: Color(0xFF8888AA), fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

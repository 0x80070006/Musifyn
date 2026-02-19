import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_service.dart';
import '../services/player_service.dart';
import '../models/media_item_model.dart';
import '../widgets/track_tile.dart';
import '../widgets/album_card.dart';
import 'album_screen.dart';
import 'player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<MediaItemModel> _results = [];
  bool _searching = false;

  void _onSearch(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _searching = true);
      final results = await context.read<JellyfinService>().searchMusic(query);
      if (mounted) setState(() { _results = results; _searching = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _results.where((r) => r.type == 'Audio').toList();
    final albums = _results.where((r) => r.type == 'MusicAlbum').toList();
    final artists = _results.where((r) => r.type == 'MusicArtist').toList();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF12122A),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF2A2A4A)),
          ),
          child: TextField(
            controller: _controller,
            onChanged: _onSearch,
            autofocus: false,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Artistes, titres, albums...',
              hintStyle: TextStyle(color: Color(0xFF555577)),
              prefixIcon: Icon(Icons.search, color: Color(0xFF7B2FBE)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
      body: _searching
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7B2FBE)))
          : _results.isEmpty
              ? const Center(
                  child: Text('Recherchez de la musique', style: TextStyle(color: Color(0xFF8888AA))),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    if (artists.isNotEmpty) ...[
                      _sectionHeader('Artistes'),
                      ...artists.map((a) => ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF1A1A3A),
                          child: Icon(Icons.person, color: Color(0xFF7B2FBE)),
                        ),
                        title: Text(a.name, style: const TextStyle(color: Colors.white)),
                        subtitle: const Text('Artiste', style: TextStyle(color: Color(0xFF8888AA))),
                      )),
                    ],
                    if (albums.isNotEmpty) ...[
                      _sectionHeader('Albums'),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: albums.length,
                          itemBuilder: (ctx, i) => AlbumCard(album: albums[i]),
                        ),
                      ),
                    ],
                    if (tracks.isNotEmpty) ...[
                      _sectionHeader('Titres'),
                      ...tracks.map((t) => TrackTile(
                        track: t,
                        onTap: () => _playTrack(t),
                      )),
                    ],
                  ],
                ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  void _playTrack(MediaItemModel track) {
    final jellyfin = context.read<JellyfinService>();
    final streamUrl = jellyfin.getStreamUrl(track.id);
    final streamTrack = MediaItemModel(
      id: track.id, name: track.name, type: track.type, serverUrl: streamUrl,
      artistName: track.artistName, albumName: track.albumName, albumId: track.albumId, durationMs: track.durationMs,
    );
    context.read<PlayerService>().playTrack(streamTrack);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }
}

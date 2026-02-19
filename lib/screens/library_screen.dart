import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_service.dart';
import '../services/player_service.dart';
import '../models/media_item_model.dart';
import '../widgets/album_card.dart';
import '../widgets/track_tile.dart';
import 'album_screen.dart';
import 'player_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MediaItemModel> _artists = [];
  List<MediaItemModel> _albums = [];
  List<MediaItemModel> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final jellyfin = context.read<JellyfinService>();
    final artists = await jellyfin.getArtists();
    final albums = await jellyfin.getAlbums();
    final favorites = await jellyfin.getFavorites();
    if (mounted) {
      setState(() {
        _artists = artists;
        _albums = albums;
        _favorites = favorites;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF7B2FBE),
          labelColor: const Color(0xFF7B2FBE),
          unselectedLabelColor: const Color(0xFF8888AA),
          tabs: const [
            Tab(text: 'Artistes'),
            Tab(text: 'Albums'),
            Tab(text: 'Favoris'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7B2FBE)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildArtistsList(),
                _buildAlbumGrid(),
                _buildFavorites(),
              ],
            ),
    );
  }

  Widget _buildArtistsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _artists.length,
      itemBuilder: (ctx, i) {
        final artist = _artists[i];
        final jellyfin = context.read<JellyfinService>();
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF7B2FBE).withOpacity(0.3),
            backgroundImage: NetworkImage(jellyfin.getImageUrl(artist.id)),
            onBackgroundImageError: (_, __) {},
            child: const Icon(Icons.person, color: Color(0xFF7B2FBE)),
          ),
          title: Text(artist.name, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF8888AA)),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ArtistScreen(artist: artist)),
          ),
        );
      },
    );
  }

  Widget _buildAlbumGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _albums.length,
      itemBuilder: (ctx, i) => AlbumCard(album: _albums[i], large: true),
    );
  }

  Widget _buildFavorites() {
    if (_favorites.isEmpty) {
      return const Center(
        child: Text('Aucun favori', style: TextStyle(color: Color(0xFF8888AA))),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _favorites.length,
      itemBuilder: (ctx, i) => TrackTile(
        track: _favorites[i],
        onTap: () => _playTrack(_favorites[i]),
      ),
    );
  }

  void _playTrack(MediaItemModel track) {
    final jellyfin = context.read<JellyfinService>();
    final streamUrl = jellyfin.getStreamUrl(track.id);
    final streamTrack = MediaItemModel(
      id: track.id,
      name: track.name,
      type: track.type,
      serverUrl: streamUrl,
      artistName: track.artistName,
      albumName: track.albumName,
      albumId: track.albumId,
      durationMs: track.durationMs,
    );
    context.read<PlayerService>().playTrack(streamTrack);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }
}

class ArtistScreen extends StatefulWidget {
  final MediaItemModel artist;
  const ArtistScreen({super.key, required this.artist});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  List<MediaItemModel> _albums = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final albums = await context.read<JellyfinService>().getAlbums(artistId: widget.artist.id);
    if (mounted) setState(() => _albums = albums);
  }

  @override
  Widget build(BuildContext context) {
    final jellyfin = context.read<JellyfinService>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.artist.name, style: const TextStyle(color: Colors.white)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    jellyfin.getImageUrl(widget.artist.id, size: 500),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A0533)),
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
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => AlbumCard(album: _albums[i], large: true),
                childCount: _albums.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 16, mainAxisSpacing: 16,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

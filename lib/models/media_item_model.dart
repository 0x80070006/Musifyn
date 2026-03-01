class MediaItemModel {
  final String id;
  final String name;
  final String type;
  final String serverUrl;
  final String? artistName;
  final String? albumName;
  final String? albumId;
  final int? year;
  final int? trackNumber;
  final int? durationMs;
  bool isFavorite;
  final String? playlistItemId; // for removal from playlists

  MediaItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.serverUrl,
    this.artistName,
    this.albumName,
    this.albumId,
    this.year,
    this.trackNumber,
    this.durationMs,
    this.isFavorite = false,
    this.playlistItemId,
  });

  factory MediaItemModel.fromJson(Map<String, dynamic> json, String serverUrl) {
    return MediaItemModel(
      id: json['Id'] ?? '',
      name: json['Name'] ?? 'Unknown',
      type: json['Type'] ?? '',
      serverUrl: serverUrl,
      artistName: json['AlbumArtist'] ?? json['Artists']?[0],
      albumName: json['Album'],
      albumId: json['AlbumId'],
      year: json['ProductionYear'],
      trackNumber: json['IndexNumber'],
      durationMs: json['RunTimeTicks'] != null
          ? (json['RunTimeTicks'] / 10000).round()
          : null,
      isFavorite: json['UserData']?['IsFavorite'] ?? false,
      playlistItemId: json['PlaylistItemId'],
    );
  }

  String imageUrl({int size = 300, String? token}) {
    final tokenParam = token != null ? '&api_key=$token' : '';
    return '$serverUrl/Items/$id/Images/Primary?width=$size&quality=90$tokenParam';
  }

  String get durationFormatted {
    if (durationMs == null) return '';
    final seconds = durationMs! ~/ 1000;
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

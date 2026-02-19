import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_item_model.dart';

class LocalPlaylist {
  final String id;
  String name;
  List<MediaItemModel> tracks;
  DateTime createdAt;

  LocalPlaylist({
    required this.id,
    required this.name,
    required this.tracks,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'tracks': tracks.map((t) => {
      'id': t.id,
      'name': t.name,
      'type': t.type,
      'serverUrl': t.serverUrl,
      'artistName': t.artistName,
      'albumName': t.albumName,
      'albumId': t.albumId,
      'durationMs': t.durationMs,
    }).toList(),
  };

  factory LocalPlaylist.fromJson(Map<String, dynamic> json) {
    return LocalPlaylist(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      tracks: (json['tracks'] as List).map((t) => MediaItemModel(
        id: t['id'],
        name: t['name'],
        type: t['type'],
        serverUrl: t['serverUrl'],
        artistName: t['artistName'],
        albumName: t['albumName'],
        albumId: t['albumId'],
        durationMs: t['durationMs'],
      )).toList(),
    );
  }
}

class PlaylistService extends ChangeNotifier {
  List<LocalPlaylist> _playlists = [];

  List<LocalPlaylist> get playlists => _playlists;

  PlaylistService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('local_playlists');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _playlists = list.map((e) => LocalPlaylist.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_playlists', jsonEncode(_playlists.map((p) => p.toJson()).toList()));
  }

  Future<LocalPlaylist> create(String name) async {
    final playlist = LocalPlaylist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      tracks: [],
      createdAt: DateTime.now(),
    );
    _playlists.add(playlist);
    await _save();
    notifyListeners();
    return playlist;
  }

  Future<void> rename(String playlistId, String newName) async {
    final playlist = _playlists.firstWhere((p) => p.id == playlistId);
    playlist.name = newName;
    await _save();
    notifyListeners();
  }

  Future<void> delete(String playlistId) async {
    _playlists.removeWhere((p) => p.id == playlistId);
    await _save();
    notifyListeners();
  }

  Future<void> addTrack(String playlistId, MediaItemModel track) async {
    final playlist = _playlists.firstWhere((p) => p.id == playlistId);
    if (!playlist.tracks.any((t) => t.id == track.id)) {
      playlist.tracks.add(track);
      await _save();
      notifyListeners();
    }
  }

  Future<void> removeTrack(String playlistId, String trackId) async {
    final playlist = _playlists.firstWhere((p) => p.id == playlistId);
    playlist.tracks.removeWhere((t) => t.id == trackId);
    await _save();
    notifyListeners();
  }

  Future<void> reorderTrack(String playlistId, int oldIndex, int newIndex) async {
    final playlist = _playlists.firstWhere((p) => p.id == playlistId);
    final track = playlist.tracks.removeAt(oldIndex);
    playlist.tracks.insert(newIndex, track);
    await _save();
    notifyListeners();
  }
}

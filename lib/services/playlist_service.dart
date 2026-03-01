import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_item_model.dart';

class LocalPlaylist {
  final String id;
  String name;
  List<MediaItemModel> tracks;
  DateTime createdAt;
  Color? color;
  String? imagePath;

  LocalPlaylist({
    required this.id,
    required this.name,
    required this.tracks,
    required this.createdAt,
    this.color,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'color': color?.value,
        'imagePath': imagePath,
        'tracks': tracks
            .map((t) => {
                  'id': t.id,
                  'name': t.name,
                  'type': t.type,
                  'serverUrl': t.serverUrl,
                  'artistName': t.artistName,
                  'albumName': t.albumName,
                  'albumId': t.albumId,
                  'durationMs': t.durationMs,
                })
            .toList(),
      };

  factory LocalPlaylist.fromJson(Map<String, dynamic> json) {
    return LocalPlaylist(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      color: json['color'] != null ? Color(json['color']) : null,
      imagePath: json['imagePath'],
      tracks: (json['tracks'] as List)
          .map((t) => MediaItemModel(
                id: t['id'],
                name: t['name'],
                type: t['type'],
                serverUrl: t['serverUrl'],
                artistName: t['artistName'],
                albumName: t['albumName'],
                albumId: t['albumId'],
                durationMs: t['durationMs'],
              ))
          .toList(),
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
    await prefs.setString(
        'local_playlists',
        jsonEncode(_playlists.map((p) => p.toJson()).toList()));
  }

  Future<LocalPlaylist> create(String name, {Color? color}) async {
    final p = LocalPlaylist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      tracks: [],
      createdAt: DateTime.now(),
      color: color ?? const Color(0xFF1DB954),
    );
    _playlists.add(p);
    await _save();
    notifyListeners();
    return p;
  }

  Future<void> update(
      String id, {
      String? name,
      Color? color,
      String? imagePath,
    }) async {
    final p = _playlists.firstWhere((p) => p.id == id);
    if (name != null) p.name = name;
    if (color != null) p.color = color;
    if (imagePath != null) p.imagePath = imagePath;
    await _save();
    notifyListeners();
  }

  Future<void> delete(String id) async {
    _playlists.removeWhere((p) => p.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> addTrack(String id, MediaItemModel track) async {
    final p = _playlists.firstWhere((p) => p.id == id);
    if (!p.tracks.any((t) => t.id == track.id)) {
      p.tracks.add(track);
      await _save();
      notifyListeners();
    }
  }

  Future<void> removeTrack(String id, String trackId) async {
    final p = _playlists.firstWhere((p) => p.id == id);
    p.tracks.removeWhere((t) => t.id == trackId);
    await _save();
    notifyListeners();
  }

  Future<void> reorder(String id, int oldIndex, int newIndex) async {
    final p = _playlists.firstWhere((p) => p.id == id);
    final track = p.tracks.removeAt(oldIndex);
    p.tracks.insert(newIndex, track);
    await _save();
    notifyListeners();
  }
}

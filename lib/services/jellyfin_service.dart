import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/media_item_model.dart';

class JellyfinService extends ChangeNotifier {
  String? _serverUrl;
  String? _userId;
  String? _token;
  String? _username;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get serverUrl => _serverUrl;
  String? get userId => _userId;
  String? get token => _token;
  String? get username => _username;

  Map<String, String> get _headers => {
    'X-Emby-Authorization':
        'MediaBrowser Client="Musifyn", Device="Android", DeviceId="musifyn-app", Version="1.0.0"'
        '${_token != null ? ', Token="$_token"' : ''}',
    'Content-Type': 'application/json',
  };

  Future<void> loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    _serverUrl = prefs.getString('server_url');
    _userId = prefs.getString('user_id');
    _token = prefs.getString('token');
    _username = prefs.getString('username');
    if (_serverUrl != null && _token != null && _userId != null) {
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<String?> login(String serverUrl, String username, String password) async {
    try {
      // Normalize URL
      final url = serverUrl.endsWith('/') ? serverUrl.substring(0, serverUrl.length - 1) : serverUrl;

      final response = await http.post(
        Uri.parse('$url/Users/AuthenticateByName'),
        headers: {
          'X-Emby-Authorization':
              'MediaBrowser Client="Musifyn", Device="Android", DeviceId="musifyn-app", Version="1.0.0"',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'Username': username, 'Pw': password}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _serverUrl = url;
        _token = data['AccessToken'];
        _userId = data['User']['Id'];
        _username = data['User']['Name'];
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('server_url', _serverUrl!);
        await prefs.setString('token', _token!);
        await prefs.setString('user_id', _userId!);
        await prefs.setString('username', _username!);

        notifyListeners();
        return null;
      } else {
        return 'Erreur ${response.statusCode}: Identifiants incorrects';
      }
    } catch (e) {
      return 'Impossible de se connecter au serveur: $e';
    }
  }

  Future<void> logout() async {
    _serverUrl = null;
    _token = null;
    _userId = null;
    _username = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<List<MediaItemModel>> getMusicLibraries() async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Users/$_userId/Views'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = (data['Items'] as List)
          .where((i) => i['CollectionType'] == 'music')
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
      return items;
    }
    return [];
  }

  Future<List<MediaItemModel>> getArtists({String? libraryId}) async {
    final url = libraryId != null
        ? '$_serverUrl/Artists?UserId=$_userId&ParentId=$libraryId&SortBy=SortName&SortOrder=Ascending&Recursive=true&ImageTypeLimit=1&EnableImageTypes=Primary'
        : '$_serverUrl/Artists?UserId=$_userId&SortBy=SortName&SortOrder=Ascending&Recursive=true&ImageTypeLimit=1&EnableImageTypes=Primary';
    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }

  Future<List<MediaItemModel>> getAlbums({String? artistId, String? libraryId}) async {
    String url;
    if (artistId != null) {
      url = '$_serverUrl/Users/$_userId/Items?AlbumArtistIds=$artistId&IncludeItemTypes=MusicAlbum&SortBy=ProductionYear&SortOrder=Descending&Recursive=true&ImageTypeLimit=1&EnableImageTypes=Primary';
    } else if (libraryId != null) {
      url = '$_serverUrl/Users/$_userId/Items?ParentId=$libraryId&IncludeItemTypes=MusicAlbum&SortBy=SortName&SortOrder=Ascending&Recursive=true&ImageTypeLimit=1&EnableImageTypes=Primary';
    } else {
      url = '$_serverUrl/Users/$_userId/Items?IncludeItemTypes=MusicAlbum&SortBy=DateCreated&SortOrder=Descending&Recursive=true&Limit=20&ImageTypeLimit=1&EnableImageTypes=Primary';
    }
    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }

  Future<List<MediaItemModel>> getAlbumTracks(String albumId) async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Users/$_userId/Items?ParentId=$albumId&SortBy=IndexNumber&SortOrder=Ascending'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }

  Future<List<MediaItemModel>> searchMusic(String query) async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Users/$_userId/Items?SearchTerm=${Uri.encodeQueryComponent(query)}&IncludeItemTypes=Audio,MusicAlbum,MusicArtist&Recursive=true&Limit=30&ImageTypeLimit=1&EnableImageTypes=Primary'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }

  Future<List<MediaItemModel>> getRecentlyPlayed() async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Users/$_userId/Items/Latest?IncludeItemTypes=Audio&Limit=20&ImageTypeLimit=1&EnableImageTypes=Primary'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((i) => MediaItemModel.fromJson(i, _serverUrl!)).toList();
    }
    return [];
  }

  Future<List<MediaItemModel>> getFavorites() async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Users/$_userId/Items?Filters=IsFavorite&IncludeItemTypes=Audio&Recursive=true&ImageTypeLimit=1&EnableImageTypes=Primary'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }

  Future<void> toggleFavorite(String itemId, bool isFavorite) async {
    if (isFavorite) {
      await http.delete(
        Uri.parse('$_serverUrl/Users/$_userId/FavoriteItems/$itemId'),
        headers: _headers,
      );
    } else {
      await http.post(
        Uri.parse('$_serverUrl/Users/$_userId/FavoriteItems/$itemId'),
        headers: _headers,
      );
    }
  }

  String getStreamUrl(String itemId) {
    return '$_serverUrl/Audio/$itemId/universal?UserId=$_userId&DeviceId=musifyn-app&MaxStreamingBitrate=140000000&Container=opus,mp3,aac,m4a,m4b,flac,webma,webm,wav,ogg,mpa,wma&TranscodingContainer=mp4&TranscodingProtocol=hls&AudioCodec=aac&api_key=$_token';
  }

  String getImageUrl(String itemId, {int size = 300}) {
    return '$_serverUrl/Items/$itemId/Images/Primary?width=$size&quality=90&api_key=$_token';
  }

  // Jellyfin playlists
  Future<List<MediaItemModel>> getPlaylists() async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Users/$_userId/Items?IncludeItemTypes=Playlist&Recursive=true&SortBy=SortName&ImageTypeLimit=1&EnableImageTypes=Primary'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }

  Future<MediaItemModel?> createPlaylist(String name) async {
    final response = await http.post(
      Uri.parse('$_serverUrl/Playlists'),
      headers: _headers,
      body: jsonEncode({
        'Name': name,
        'UserId': _userId,
        'MediaType': 'Audio',
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MediaItemModel(
        id: data['Id'],
        name: name,
        type: 'Playlist',
        serverUrl: _serverUrl!,
      );
    }
    return null;
  }

  Future<void> addToPlaylist(String playlistId, String itemId) async {
    await http.post(
      Uri.parse('$_serverUrl/Playlists/$playlistId/Items?Ids=$itemId&UserId=$_userId'),
      headers: _headers,
    );
  }

  Future<void> removeFromPlaylist(String playlistId, String entryId) async {
    await http.delete(
      Uri.parse('$_serverUrl/Playlists/$playlistId/Items?EntryIds=$entryId'),
      headers: _headers,
    );
  }

  Future<List<MediaItemModel>> getPlaylistItems(String playlistId) async {
    final response = await http.get(
      Uri.parse('$_serverUrl/Playlists/$playlistId/Items?UserId=$_userId&ImageTypeLimit=1&EnableImageTypes=Primary'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['Items'] as List)
          .map((i) => MediaItemModel.fromJson(i, _serverUrl!))
          .toList();
    }
    return [];
  }
}

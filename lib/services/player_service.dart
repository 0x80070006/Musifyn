import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/media_item_model.dart';

class PlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  
  List<MediaItemModel> _queue = [];
  int _currentIndex = -1;
  bool _shuffle = false;
  LoopMode _loopMode = LoopMode.off;

  List<MediaItemModel> get queue => _queue;
  int get currentIndex => _currentIndex;
  MediaItemModel? get currentTrack => _currentIndex >= 0 && _currentIndex < _queue.length ? _queue[_currentIndex] : null;
  bool get isPlaying => _player.playing;
  bool get shuffle => _shuffle;
  LoopMode get loopMode => _loopMode;
  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  PlayerService() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onTrackComplete();
      }
      notifyListeners();
    });
  }

  void _onTrackComplete() {
    if (_loopMode == LoopMode.one) {
      _player.seek(Duration.zero);
      _player.play();
    } else {
      skipNext();
    }
  }

  Future<void> playTrack(MediaItemModel track, {List<MediaItemModel>? queue, int? index}) async {
    if (queue != null) {
      _queue = queue;
      _currentIndex = index ?? queue.indexOf(track);
    } else if (!_queue.contains(track)) {
      _queue.add(track);
      _currentIndex = _queue.length - 1;
    } else {
      _currentIndex = _queue.indexOf(track);
    }
    await _loadAndPlay();
  }

  Future<void> _loadAndPlay() async {
    if (_currentIndex < 0 || _currentIndex >= _queue.length) return;
    final track = _queue[_currentIndex];
    try {
      await _player.setUrl(track.serverUrl);
      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint('Player error: $e');
    }
  }

  Future<void> playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    notifyListeners();
  }

  Future<void> skipNext() async {
    if (_queue.isEmpty) return;
    if (_shuffle) {
      _currentIndex = (DateTime.now().millisecondsSinceEpoch % _queue.length).toInt();
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    await _loadAndPlay();
  }

  Future<void> skipPrevious() async {
    if (_queue.isEmpty) return;
    final pos = await _player.position;
    if (pos.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else {
      _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
      await _loadAndPlay();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  void cycleLoopMode() {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _loopMode = LoopMode.off;
        break;
    }
    _player.setLoopMode(_loopMode);
    notifyListeners();
  }

  void addToQueue(MediaItemModel track) {
    _queue.add(track);
    notifyListeners();
  }

  Future<void> setStreamUrl(String url) async {
    if (_queue.isNotEmpty && _currentIndex >= 0) {
      _queue[_currentIndex] = MediaItemModel(
        id: _queue[_currentIndex].id,
        name: _queue[_currentIndex].name,
        type: _queue[_currentIndex].type,
        serverUrl: url,
        artistName: _queue[_currentIndex].artistName,
        albumName: _queue[_currentIndex].albumName,
        albumId: _queue[_currentIndex].albumId,
        durationMs: _queue[_currentIndex].durationMs,
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

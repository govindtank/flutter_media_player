import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:flutter/foundation.dart';

enum PlaybackMode { off, repeatOne, repeatAll }

class PlaylistProvider extends ChangeNotifier {
  final List<MediaItem> _queue = [];
  int _currentIndex = -1;
  PlaybackMode _mode = PlaybackMode.off;

  List<MediaItem> get queue => List.unmodifiable(_queue);
  int get currentIndex => _currentIndex;
  MediaItem? get currentItem =>
      _currentIndex >= 0 && _currentIndex < _queue.length ? _queue[_currentIndex] : null;
  PlaybackMode get mode => _mode;

  bool get hasPrevious => _currentIndex > 0;
  bool get hasNext {
    if (_currentIndex < 0) return false;
    if (_mode == PlaybackMode.repeatOne) return true;
    return _currentIndex < _queue.length - 1 || _mode == PlaybackMode.repeatAll;
  }

  void setQueue(List<MediaItem> items, {int startIndex = 0}) {
    _queue.clear();
    _queue.addAll(items);
    _currentIndex = startIndex.clamp(0, items.length - 1);
    notifyListeners();
  }

  void addToQueue(MediaItem item) {
    _queue.add(item);
    notifyListeners();
  }

  MediaItem? next() {
    if (_queue.isEmpty) return null;

    if (_mode == PlaybackMode.repeatOne) {
      return currentItem;
    }

    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      notifyListeners();
      return currentItem;
    }

    if (_mode == PlaybackMode.repeatAll) {
      _currentIndex = 0;
      notifyListeners();
      return currentItem;
    }

    return null;
  }

  MediaItem? previous() {
    if (_queue.isEmpty || _currentIndex <= 0) return null;

    _currentIndex--;
    notifyListeners();
    return currentItem;
  }

  void setMode(PlaybackMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void clear() {
    _queue.clear();
    _currentIndex = -1;
    notifyListeners();
  }
}

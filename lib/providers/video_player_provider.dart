import 'dart:async';

import 'package:flutter_media_player/models/media_item.dart';
import 'package:flutter_media_player/providers/media_player.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerProvider extends MediaPlayer with ChangeNotifier {
  VideoPlayerController? _controller;
  MediaItem? _currentItem;
  bool _disposed = false;
  StreamSubscription<Duration>? _positionSub;

  MediaItem? get currentItem => _currentItem;
  VideoPlayerController? get controller => _controller;

  @override
  Stream<Duration> get positionStream {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Stream.empty();
    }
    return Stream.periodic(const Duration(milliseconds: 250)).map((_) {
      if (_disposed || _controller == null || !_controller!.value.isInitialized) {
        return Duration.zero;
      }
      return _controller!.value.position;
    });
  }

  @override
  Stream<Duration?> get durationStream {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Stream.empty();
    }
    return Stream.value(_controller!.value.duration);
  }

  @override
  Stream<bool> get playingStream {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Stream.empty();
    }
    return Stream.periodic(const Duration(milliseconds: 250)).map((_) {
      if (_disposed || _controller == null || !_controller!.value.isInitialized) {
        return false;
      }
      return _controller!.value.isPlaying;
    });
  }

  @override
  Stream<AppPlayerState> get stateStream async* {
    if (_controller == null) {
      yield AppPlayerState.idle;
      return;
    }
    await for (final _ in positionStream) {
      if (_disposed || _controller == null) break;
      if (!_controller!.value.isInitialized) {
        yield AppPlayerState.loading;
      } else if (_controller!.value.isPlaying) {
        yield AppPlayerState.playing;
      } else {
        yield AppPlayerState.paused;
      }
    }
  }

  @override
  Future<void> load(MediaItem item) async {
    if (_disposed) return;
    await _controller?.dispose();
    await _positionSub?.cancel();
    _currentItem = item;

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(item.url));
      await _controller!.initialize();
      notifyListeners();
    } catch (e) {
      debugPrint('VideoPlayerProvider error: $e');
      _controller = null;
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    if (_disposed || _controller == null) return;
    await _controller!.play();
    notifyListeners();
  }

  @override
  Future<void> pause() async {
    if (_disposed || _controller == null) return;
    await _controller!.pause();
    notifyListeners();
  }

  @override
  Future<void> stop() async {
    if (_disposed || _controller == null) return;
    await _controller!.pause();
    await _controller!.seekTo(Duration.zero);
    _currentItem = null;
    notifyListeners();
  }

  @override
  Future<void> seek(Duration position) async {
    if (_disposed || _controller == null) return;
    await _controller!.seekTo(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_disposed || _controller == null) return;
    await _controller!.setVolume(volume);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    if (_disposed || _controller == null) return;
    await _controller!.setPlaybackSpeed(speed);
  }

  @override
  void dispose() {
    _disposed = true;
    _positionSub?.cancel();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}

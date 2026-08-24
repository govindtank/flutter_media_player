import 'dart:async';

import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:audio_video_youtube_player/providers/media_player.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider extends MediaPlayer with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  MediaItem? _currentItem;

  MediaItem? get currentItem => _currentItem;
  bool get isPlaying => _player.playing;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Stream<AppPlayerState> get stateStream => _player.playerStateStream.map((state) {
    if (state.processingState == ProcessingState.idle) {
      return AppPlayerState.idle;
    } else if (state.processingState == ProcessingState.loading ||
               state.processingState == ProcessingState.buffering) {
      return AppPlayerState.loading;
    } else if (state.playing) {
      return AppPlayerState.playing;
    } else {
      return AppPlayerState.paused;
    }
  }).distinct();

  @override
  Future<void> load(MediaItem item) async {
    _currentItem = item;
    try {
      await _player.setUrl(item.url);
      notifyListeners();
    } on PlayerException catch (e) {
      debugPrint('AudioPlayerProvider error: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> play() async => _player.play();

  @override
  Future<void> pause() async => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    _currentItem = null;
    notifyListeners();
  }

  @override
  Future<void> seek(Duration position) async => _player.seek(position);

  @override
  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

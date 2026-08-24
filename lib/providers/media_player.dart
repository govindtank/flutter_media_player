import 'package:flutter_media_player/models/media_item.dart';

enum AppPlayerState { idle, loading, playing, paused, error }

enum PlaybackMode { off, repeatOne, repeatAll }

abstract class MediaPlayer {
  Future<void> load(MediaItem item);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setPlaybackSpeed(double speed);

  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<bool> get playingStream;
  Stream<AppPlayerState> get stateStream;
}

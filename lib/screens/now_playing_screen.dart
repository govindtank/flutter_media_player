import 'dart:async';

import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:audio_video_youtube_player/providers/audio_player_provider.dart';
import 'package:audio_video_youtube_player/providers/video_player_provider.dart';
import 'package:audio_video_youtube_player/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    final videoProvider = Provider.of<VideoPlayerProvider>(context);

    final audioItem = audioProvider.currentItem;
    final videoItem = videoProvider.currentItem;
    final mediaItem = audioItem ?? videoItem;

    if (mediaItem == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Now Playing'),
        ),
        body: const Center(
          child: Text('No media playing found!'),
        ),
      );
    }

    final isAudio = audioItem != null;
    final isPlaying = isAudio
        ? audioProvider.isPlaying
        : videoProvider.controller?.value.isPlaying ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: _NowPlayingContent(
        isAudio: isAudio,
        isPlaying: isPlaying,
      ),
    );
  }
}

class _NowPlayingContent extends StatelessWidget {
  final bool isAudio;
  final bool isPlaying;

  const _NowPlayingContent({required this.isAudio, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    final audioItem = audioProvider.currentItem;
    final videoItem = videoProvider.currentItem;
    final mediaItem = audioItem ?? videoItem;

    if (mediaItem == null) {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (!isAudio && videoProvider.controller != null)
          AspectRatio(
            aspectRatio: videoProvider.controller!.value.aspectRatio,
            child: VideoPlayer(videoProvider.controller!),
          ),
        const SizedBox(height: 32),
        Text(
          mediaItem.title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (mediaItem.artist != null) ...[
          const SizedBox(height: 8),
          Text(
            mediaItem.artist!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 32),
        _PlaybackControls(
          isAudio: isAudio,
          isPlaying: isPlaying,
        ),
        const SizedBox(height: 24),
        _SeekBar(
          isAudio: isAudio,
        ),
        const SizedBox(height: 16),
        _SpeedControl(isAudio: isAudio),
        const SizedBox(height: 16),
        _VolumeControl(isAudio: isAudio),
        if (!isAudio && videoProvider.controller != null) ...[
          const SizedBox(height: 16),
          _FullscreenButton(controller: videoProvider.controller!),
        ],
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  final bool isAudio;
  final bool isPlaying;

  const _PlaybackControls({required this.isAudio, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (playlistProvider.hasPrevious)
          IconButton(
            icon: const Icon(Icons.skip_previous),
            iconSize: 48,
            onPressed: () {
              final prev = playlistProvider.previous();
              if (prev != null) {
                _playItem(context, prev);
              }
            },
          ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 64,
          onPressed: () {
            if (isPlaying) {
              if (isAudio) {
                audioProvider.pause();
              } else {
                videoProvider.pause();
              }
            } else {
              if (isAudio) {
                audioProvider.play();
              } else {
                videoProvider.play();
              }
            }
          },
        ),
        if (playlistProvider.hasNext)
          IconButton(
            icon: const Icon(Icons.skip_next),
            iconSize: 48,
            onPressed: () {
              final next = playlistProvider.next();
              if (next != null) {
                _playItem(context, next);
              }
            },
          ),
      ],
    );
  }

  Future<void> _playItem(BuildContext context, MediaItem item) async {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);

    if (item.isVideo) {
      await videoProvider.load(item);
      await videoProvider.play();
    } else {
      await audioProvider.load(item);
      await audioProvider.play();
    }
  }
}

class _SeekBar extends StatefulWidget {
  final bool isAudio;

  const _SeekBar({required this.isAudio});

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  bool _isDragging = false;
  Duration _dragPosition = Duration.zero;

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);

    Duration position;
    Duration? duration;

    if (widget.isAudio) {
      position = Duration.zero;
      duration = null;
    } else {
      final controller = videoProvider.controller;
      if (controller == null || !controller.value.isInitialized) {
        position = Duration.zero;
        duration = null;
      } else {
        position = _isDragging ? _dragPosition : controller.value.position;
        duration = controller.value.duration;
      }
    }

    final progress = duration != null && duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              setState(() {
                _isDragging = true;
                _dragPosition = Duration(
                  milliseconds: (value * (duration?.inMilliseconds ?? 0)).round(),
                );
              });
            },
            onChangeEnd: (value) {
              setState(() => _isDragging = false);
              final seekPosition = Duration(
                milliseconds: (value * (duration?.inMilliseconds ?? 0)).round(),
              );
              if (widget.isAudio) {
                audioProvider.seek(seekPosition);
              } else {
                videoProvider.seek(seekPosition);
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(position)),
            if (duration != null)
              Text(_formatDuration(duration))
            else
              const Text('--:--'),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _SpeedControl extends StatelessWidget {
  final bool isAudio;

  const _SpeedControl({required this.isAudio});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Speed: '),
        DropdownButton<double>(
          value: 1.0,
          items: const [
            DropdownMenuItem(value: 0.5, child: Text('0.5x')),
            DropdownMenuItem(value: 0.75, child: Text('0.75x')),
            DropdownMenuItem(value: 1.0, child: Text('1.0x')),
            DropdownMenuItem(value: 1.25, child: Text('1.25x')),
            DropdownMenuItem(value: 1.5, child: Text('1.5x')),
            DropdownMenuItem(value: 2.0, child: Text('2.0x')),
          ],
          onChanged: (value) {
            if (value == null) return;
            if (isAudio) {
              audioProvider.setPlaybackSpeed(value);
            } else {
              videoProvider.setPlaybackSpeed(value);
            }
          },
        ),
      ],
    );
  }
}

class _VolumeControl extends StatelessWidget {
  final bool isAudio;

  const _VolumeControl({required this.isAudio});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.volume_down),
        const SizedBox(width: 16),
        Expanded(
          child: Slider(
            value: 1.0,
            onChanged: (value) {
              if (isAudio) {
                audioProvider.setVolume(value);
              } else {
                videoProvider.setVolume(value);
              }
            },
          ),
        ),
        const Icon(Icons.volume_up),
      ],
    );
  }
}

class _FullscreenButton extends StatelessWidget {
  final VideoPlayerController controller;

  const _FullscreenButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _FullscreenVideoPage(controller: controller),
            ),
          );
        },
        icon: const Icon(Icons.fullscreen),
        label: const Text('Fullscreen'),
      ),
    );
  }
}

class _FullscreenVideoPage extends StatelessWidget {
  final VideoPlayerController controller;

  const _FullscreenVideoPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

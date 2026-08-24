import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:audio_video_youtube_player/providers/audio_player_provider.dart';
import 'package:audio_video_youtube_player/providers/video_player_provider.dart';
import 'package:audio_video_youtube_player/providers/playlist_provider.dart';
import 'package:audio_video_youtube_player/screens/now_playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioPlayerProvider>();
    final videoProvider = context.watch<VideoPlayerProvider>();
    final playlistProvider = context.watch<PlaylistProvider>();

    final audioItem = audioProvider.currentItem;
    final videoItem = videoProvider.currentItem;
    final currentItem = audioItem ?? videoItem;

    if (currentItem == null) return const SizedBox.shrink();

    final isAudio = audioItem != null;
    final isPlaying = isAudio
        ? audioProvider.isPlaying
        : videoProvider.controller?.value.isPlaying ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NowPlayingScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: currentItem.thumbnailUrl != null
                  ? Image.network(
                      currentItem.thumbnailUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 48,
                          height: 48,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            isAudio ? Icons.music_note : Icons.play_circle_filled,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        isAudio ? Icons.music_note : Icons.play_circle_filled,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
            ),
            title: Text(
              currentItem.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: currentItem.artist != null
                ? Text(
                    currentItem.artist!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (playlistProvider.hasNext || playlistProvider.hasPrevious)
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () {
                      final prev = playlistProvider.previous();
                      if (prev != null) {
                        _playItem(context, prev, audioProvider, videoProvider);
                      }
                    },
                    tooltip: 'Previous',
                  ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
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
                  tooltip: isPlaying ? 'Pause' : 'Play',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _playItem(
    BuildContext context,
    MediaItem item,
    AudioPlayerProvider audioProvider,
    VideoPlayerProvider videoProvider,
  ) async {
    if (item.isVideo) {
      await videoProvider.load(item);
      await videoProvider.play();
    } else {
      await audioProvider.load(item);
      await audioProvider.play();
    }
  }
}

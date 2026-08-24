import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:audio_video_youtube_player/providers/video_player_provider.dart';
import 'package:audio_video_youtube_player/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  static List<MediaItem> get _videos => const [
        MediaItem(
          id: 'video_1',
          title: 'Big Buck Bunny',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          isVideo: true,
          thumbnailUrl: 'https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg',
          duration: Duration(seconds: 596),
        ),
        MediaItem(
          id: 'video_2',
          title: 'Elephant Dream',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          isVideo: true,
          thumbnailUrl: 'https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg',
          duration: Duration(seconds: 653),
        ),
        MediaItem(
          id: 'video_3',
          title: 'For Bigger Blazes',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          isVideo: true,
          thumbnailUrl: 'https://i.ytimg.com/vi/aqz-KE-bpKQ/maxresdefault.jpg',
          duration: Duration(seconds: 15),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return ListView.builder(
      itemCount: _videos.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final video = _videos[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: video.thumbnailUrl != null
                ? Image.network(
                    video.thumbnailUrl!,
                    width: 80,
                    height: 45,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 45,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.play_circle_filled),
                      );
                    },
                  )
                : Container(
                    width: 80,
                    height: 45,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.play_circle_filled),
                  ),
          ),
          title: Text(video.title),
          subtitle: video.duration != null
              ? Text(_formatDuration(video.duration!))
              : null,
          trailing: const Icon(Icons.play_circle_filled, size: 32),
          onTap: () async {
            playlistProvider.setQueue(_videos, startIndex: index);
            await videoProvider.load(video);
            await videoProvider.play();
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

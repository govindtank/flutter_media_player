import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:audio_video_youtube_player/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_youtube_player/screens/youtube_player_screen.dart';

class YoutubeList extends StatelessWidget {
  const YoutubeList({super.key});

  static const List<MediaItem> _youtubeVideos = [
    MediaItem(
      id: 'yt_1',
      title: 'Rick Astley - Never Gonna Give You Up',
      url: 'dQw4w9WgXcQ',
      isVideo: true,
      youtubeId: 'dQw4w9WgXcQ',
      thumbnailUrl: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    ),
    MediaItem(
      id: 'yt_2',
      title: 'Me at the zoo',
      url: 'jNQXAC9IVRw',
      isVideo: true,
      youtubeId: 'jNQXAC9IVRw',
      thumbnailUrl: 'https://i.ytimg.com/vi/jNQXAC9IVRw/maxresdefault.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return ListView.builder(
      itemCount: _youtubeVideos.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final video = _youtubeVideos[index];
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
          trailing: const Icon(Icons.play_circle_filled, size: 32),
          onTap: () async {
            playlistProvider.setQueue(_youtubeVideos, startIndex: index);
            if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => YoutubePlayerScreen(videoId: video.url),
                ),
              );
            }
          },
        );
      },
    );
  }
}

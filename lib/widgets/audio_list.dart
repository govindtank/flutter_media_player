import 'package:audio_video_youtube_player/models/media_item.dart';
import 'package:audio_video_youtube_player/providers/audio_player_provider.dart';
import 'package:audio_video_youtube_player/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioList extends StatelessWidget {
  const AudioList({super.key});

  static List<MediaItem> get _audios => [
        const MediaItem(
          id: 'audio_1',
          title: 'SoundHelix Song 1',
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          isVideo: false,
          artist: 'SoundHelix',
        ),
        const MediaItem(
          id: 'audio_2',
          title: 'SoundHelix Song 2',
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
          isVideo: false,
          artist: 'SoundHelix',
        ),
        const MediaItem(
          id: 'audio_3',
          title: 'SoundHelix Song 3',
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
          isVideo: false,
          artist: 'SoundHelix',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return ListView.builder(
      itemCount: _audios.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final audio = _audios[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.music_note,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(audio.title),
          subtitle: Text(audio.artist ?? 'Unknown Artist'),
          trailing: const Icon(Icons.play_circle_filled, size: 32),
          onTap: () async {
            playlistProvider.setQueue(_audios, startIndex: index);
            await audioProvider.load(audio);
            await audioProvider.play();
          },
        );
      },
    );
  }
}

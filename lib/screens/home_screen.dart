import 'package:audio_video_youtube_player/screens/youtube_shorts_screen.dart';
import 'package:audio_video_youtube_player/widgets/audio_list.dart';
import 'package:audio_video_youtube_player/widgets/mini_player.dart';
import 'package:audio_video_youtube_player/widgets/video_list.dart';
import 'package:audio_video_youtube_player/widgets/youtube_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.audiotrack, color: Theme.of(context).colorScheme.primary),
                        text: 'Audio',
                      ),
                      Tab(
                        icon: Icon(Icons.videocam, color: Theme.of(context).colorScheme.primary),
                        text: 'Video',
                      ),
                      Tab(
                        icon: Icon(Icons.play_circle_filled, color: Theme.of(context).colorScheme.primary),
                        text: 'YouTube',
                      ),
                      Tab(
                        icon: Icon(Icons.short_text, color: Theme.of(context).colorScheme.primary),
                        text: 'Shorts',
                      ),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        AudioList(),
                        VideoList(),
                        YoutubeList(),
                        YoutubeShortsScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}

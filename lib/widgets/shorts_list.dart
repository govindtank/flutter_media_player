import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ShortsList extends StatefulWidget {
  const ShortsList({super.key});

  @override
  State<ShortsList> createState() => _ShortsListState();
}

class _ShortsListState extends State<ShortsList> {
  static const List<String> _shortsIds = [
    'dQw4w9WgXcQ',
    '3JZ_D3ELwOQ',
  ];

  late final List<YoutubePlayerController> _controllers;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controllers = _shortsIds
        .map(
          (id) => YoutubePlayerController(
                params: const YoutubePlayerParams(
                  showControls: false,
                  showFullscreenButton: false,
                  loop: true,
                ),
              )..loadVideoById(videoId: id),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.close();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _shortsIds.length,
        itemBuilder: (context, index) {
          return YoutubePlayer(
            controller: _controllers[index],
            aspectRatio: 9 / 16,
          );
        },
      ),
    );
  }
}

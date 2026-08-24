class MediaItem {
  final String id;
  final String title;
  final String url;
  final bool isVideo;
  final String? youtubeId;
  final String? thumbnailUrl;
  final String? artist;
  final Duration? duration;

  const MediaItem({
    required this.id,
    required this.title,
    required this.url,
    required this.isVideo,
    this.youtubeId,
    this.thumbnailUrl,
    this.artist,
    this.duration,
  });
}

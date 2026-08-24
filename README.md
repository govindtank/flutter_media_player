# Audio Video YouTube Player

A Flutter sample app demonstrating multi-format media playback: **local/network audio**, **network video**, **YouTube videos**, and **YouTube Shorts**. Built to validate cross-platform (mobile + web) media player behavior using a shared provider architecture.

## Features

| Feature | Package | Status |
|---------|---------|--------|
| Audio Player (MP3/stream) | `just_audio` | ✅ Working |
| Video Player (MP4/network) | `video_player` | ✅ Working |
| YouTube Video Player | `youtube_player_iframe` | ✅ Working |
| YouTube Shorts | `youtube_player_iframe` + `tiktoklikescroller` | ⚠️ Partial |

## Architecture

```
lib/
├── main.dart                    # App entry, ChangeNotifier provider setup
├── models/
│   └── media_item.dart          # Media metadata model
├── providers/
│   └── media_provider.dart      # Central playback state (audio + video)
├── screens/
│   ├── home_screen.dart         # Tab-based launcher
│   ├── now_playing_screen.dart  # Expanded playback view
│   ├── youtube_player_screen.dart
│   ├── youtube_shorts_screen.dart
│   ├── shorts_by_video_url.dart # Legacy/disabled code
│   └── VideoListPage.dart       # Grid-based YouTube list
└── widgets/
    ├── mini_player.dart         # Bottom persistent player
    ├── audio_list.dart
    ├── video_list.dart
    ├── youtube_list.dart
    └── shorts_list.dart         # Vertical swipe implementation
```

### State Flow

1. User taps a media item in a list widget.
2. `MediaProvider.playMedia()` initializes the correct player (`just_audio` for audio, `VideoPlayerController` for video).
3. `MiniPlayer` reacts via `Consumer<MediaProvider>`.
4. Tapping `MiniPlayer` opens `NowPlayingScreen` for expanded controls.

## Getting Started

### Prerequisites

- Flutter SDK `>=3.4.0 <4.0.0`
- Dart SDK `>=3.4.0`
- For Android: API 21+
- For iOS: iOS 12+

### Installation

```bash
# Clone the repo
git clone https://github.com/govindtank/audio_video_youtube_player.git

# Navigate
cd audio_video_youtube_player

# Install dependencies
flutter pub get

# Run
flutter run
```

### Web Support

This project was originally validated on **Flutter Web**. The `CustomHttpOverrides` in `main.dart` disables certificate validation for development purposes only.

```bash
flutter run -d chrome
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `just_audio` | Audio playback engine |
| `video_player` | Network video playback |
| `youtube_player_iframe` | Web-view-based YouTube embed |
| `audioplayers` | ⚠️ Redundant with `just_audio` |
| `tiktoklikescroller` | Vertical swipe for Shorts UI |
| `youtube_shorts` | ⚠️ Unused / experimental |
| `video_shop_flutter` | ⚠️ Unused |

## Platform Setup

### Android

No additional setup required. `INTERNET` permission is declared in `AndroidManifest.xml`.

### iOS

Standard Flutter iOS runner. No additional entitlements required for embedded YouTube playback via iframe.

### Web

Works out of the box. The iframe YouTube player requires a web context.

## Current Limitations

- No seeking, duration, or progress indicators
- No playlist/queue support
- No error handling or loading states
- No background audio support
- Hardcoded sample URLs only
- `MediaProvider` mixes audio/video state in a single class
- Nested `MaterialApp` in `YoutubeShortsScreen`
- Redundant `audioplayers` dependency alongside `just_audio`
- Commented-out legacy code in `shorts_by_video_url.dart`

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for the phased improvement plan.

## License

MIT

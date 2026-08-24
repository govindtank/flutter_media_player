# Roadmap

## Phase 1 — Stabilize & Clean (Week 1)

**Goal:** Remove tech debt, fix runtime issues, and establish a clean baseline.

### 1.1 Dependency Cleanup
- [ ] Remove redundant `audioplayers` (keep `just_audio` only)
- [ ] Remove unused `youtube_shorts` and `video_shop_flutter`
- [ ] Run `flutter pub upgrade --major-versions` to align all packages
- [ ] Add `flutter_launcher_icons` and generate consistent app icons

### 1.2 Code Hygiene
- [ ] Delete `lib/screens/shorts_by_video_url.dart` (entirely commented out)
- [ ] Remove nested `MaterialApp` from `YoutubeShortsScreen`
- [ ] Replace `HttpOverrides` badCertificateCallback with proper certificate handling or remove for release builds
- [ ] Add `analysis_options.yaml` with strict lint rules (`flutter_lints` + custom rules)
- [ ] Add `.gitignore` entries for `build/`, `.dart_tool/`, `*.iml`, `.idea/`

### 1.3 Architecture Fixes
- [ ] Split `MediaProvider` into `AudioPlayerProvider` and `VideoPlayerProvider`
- [ ] Add abstract `MediaPlayer` interface to unify audio/video operations
- [ ] Introduce `PlayerState` enum (`idle`, `loading`, `playing`, `paused`, `error`)
- [ ] Add proper `dispose()` lifecycle handling for controllers

### 1.4 Error & Loading States
- [ ] Add loading spinners during player initialization
- [ ] Add error banners with retry for failed media loads
- [ ] Handle `AudioPlayer` `PlayerException` events
- [ ] Handle `VideoPlayerController` initialization failures

---

## Phase 2 — Core Playback UX (Week 2)

**Goal:** Make the app feel like a real media player, not a demo.

### 2.1 Playback Controls
- [ ] Add seek bar with buffered/duration indicators (audio + video)
- [ ] Add skip forward/backward buttons (±10s)
- [ ] Add playback speed control (0.5x – 2.0x)
- [ ] Add volume slider and mute toggle
- [ ] Add picture-in-picture (PiP) support for video

### 2.2 Queue & Playlist
- [ ] Add `PlaylistProvider` with `currentIndex`, `hasNext`, `hasPrevious`
- [ ] Auto-advance to next track when current ends
- [ ] Add shuffle and repeat modes (off / one / all)
- [ ] Persist queue across app restarts (Hive or shared_preferences)

### 2.3 Now Playing Screen
- [ ] Add album art / video thumbnail display
- [ ] Add immersive fullscreen video mode with landscape lock
- [ ] Add lock-screen / notification media controls (`audio_service`)
- [ ] Add haptic feedback on play/pause toggle

---

## Phase 3 — Content & Navigation (Week 3)

**Goal:** Turn the sample lists into a real content experience.

### 3.1 Data Layer
- [ ] Replace hardcoded lists with a `MediaRepository` abstraction
- [ ] Add sample JSON data in `assets/data/` (10+ audio, 10+ video, 20+ YouTube)
- [ ] Add search/filter within each tab
- [ ] Add recent media history

### 3.2 YouTube Integration
- [ ] Add YouTube search via YouTube Data API (or yt-dlp backend)
- [ ] Parse YouTube URLs to extract video IDs
- [ ] Add video metadata fetch (title, thumbnail, duration)
- [ ] Add “Open in YouTube” external link button

### 3.3 Shorts Experience
- [ ] Replace `tiktoklikescroller` with native `PageView` vertical swipe
- [ ] Add like/comment/share placeholder buttons (UI only)
- [ ] Add Shorts tab in main player bar for quick access
- [ ] Auto-play next Short on swipe

---

## Phase 4 — Polish & Production Readiness (Week 4)

**Goal:** Material You polish, performance, and release readiness.

### 4.1 UI/UX Polish
- [ ] Migrate to Material 3 (`ThemeData(useMaterial3: true)`)
- [ ] Add dynamic color / Material You token support (Android 12+)
- [ ] Add dark mode fidelity (test all screens in dark theme)
- [ ] Add splash screen and adaptive launcher icon
- [ ] Add hero animations for list-to-now-playing transitions

### 4.2 Performance
- [ ] Add `AutomaticKeepAliveClientMixin` to list tabs
- [ ] Lazy-load video thumbnails with `cached_network_image`
- [ ] Dispose controllers on tab change (not just on app exit)
- [ ] Profile memory usage with DevTools; fix leaks

### 4.3 Testing
- [ ] Add widget tests for `MediaProvider` state transitions
- [ ] Add widget tests for `MiniPlayer` and `NowPlayingScreen`
- [ ] Add integration test for full play → pause → seek flow
- [ ] CI setup: `flutter test` on PR via GitHub Actions

### 4.4 Release Prep
- [ ] Add `flutter_launcher_icons` and `flutter_native_splash`
- [ ] Add release build scripts (`build-apk`, `build-ipa`, `build-web`)
- [ ] Add `CHANGELOG.md` and semantic versioning
- [ ] Add GitHub release workflow with artifact upload

---

## Future Ideas (Post-Release)

- Offline downloads with `flutter_downloader` + local storage
- Cast to Chromecast / AirPlay
- Podcast/RSS feed support
- Equalizer and audio effects
- Multi-user profiles with separate histories
- Android widget / iOS widget for quick controls

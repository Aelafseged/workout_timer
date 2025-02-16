// lib/core/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';

/// Service for handling audio playback
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  /// Play sound from assets
  Future<void> playSound(String assetPath) async {
    await _player.play(AssetSource(assetPath));
  }

  /// Dispose resources
  void dispose() {
    _player.dispose();
  }
}
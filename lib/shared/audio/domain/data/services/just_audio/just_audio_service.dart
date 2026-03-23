import 'package:just_audio/just_audio.dart';

import '../../../repositories/audio_repository.dart';

class JustAudioService implements AudioRepository {
  final AudioPlayer _touchPlayer = AudioPlayer();
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _winPlayer = AudioPlayer();

  @override
  Future<void> init() async {
    await _touchPlayer.setAsset('assets/sounds/touch.mp3');
    await _successPlayer.setAsset('assets/sounds/success.mp3');
    await _winPlayer.setAsset('assets/sounds/win.wav');
  }

  @override
  void playTouch() async {
    await _touchPlayer.stop(); // Corta o som se o jogador clicar super rápido
    await _touchPlayer.seek(Duration.zero);
    _touchPlayer.play();
  }

  @override
  void playSuccess() async {
    await _successPlayer.stop();
    await _successPlayer.seek(Duration.zero);
    _successPlayer.play();
  }

  @override
  void playWin() async {
    await _winPlayer.stop();
    await _winPlayer.seek(Duration.zero);
    _winPlayer.play();
  }

  @override
  void dispose() {
    _touchPlayer.dispose();
    _successPlayer.dispose();
    _winPlayer.dispose();
  }
}

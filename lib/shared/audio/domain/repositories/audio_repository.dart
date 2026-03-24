abstract interface class AudioRepository {
  Future<void> init();
  void playTouch();
  void playSuccess();
  void playWin();
  void dispose();
}

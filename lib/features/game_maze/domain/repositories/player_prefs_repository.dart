import '../entities/player_prefs_entity.dart';

abstract interface class PlayerPrefsRepository {
  Future<PlayerPrefsEntity> load();
  Future<void> save(PlayerPrefsEntity playerPrefs);
}

import 'package:get_it/get_it.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../features/game_maze/data/services/secure_shared_preferences/ssp_player_prefs_service.dart';
import '../features/game_maze/domain/repositories/player_prefs_repository.dart';

abstract class DI {
  static late GetIt instance;

  static Future<void> initialize() async {
    instance = GetIt.instance;
    await _register();
  }

  static Future<void> _register() async {
    _registerCore();
    _registerGameMazeBindings();
  }

  static Future<void> _registerCore() async {
    final ssp = await SecureSharedPref.getInstance();
    instance.registerLazySingleton<SecureSharedPref>(() => ssp);
  }

  static void _registerGameMazeBindings() {
    instance.registerLazySingleton<PlayerPrefsRepository>(
      () => SspPlayerPrefsService(ssp: instance<SecureSharedPref>()),
    );
  }
}
